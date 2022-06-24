/* RI-1: Uma Categoria não pode estar contida em si própria */
CREATE OR REPLACE FUNCTION chk_cat_owns_self() RETURNS TRIGGER AS
$$
BEGIN 
  IF NEW.super_categoria = NEW.categoria THEN
    RAISE EXCEPTION 'A category cant have itself';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_cat_owns_self ON tem_outra;
CREATE TRIGGER trigger_cat_owns_self
  BEFORE UPDATE OR INSERT ON tem_outra
  FOR EACH ROW EXECUTE PROCEDURE chk_cat_owns_self();

/* RI-4: O número de unidades repostas num evento de reposição não pode exceder o número de unidades especificado no planograma */
CREATE OR REPLACE FUNCTION chk_oversupply() RETURNS TRIGGER AS
$$
DECLARE max_units INTEGER;
BEGIN
	SELECT unidades INTO max_units
		FROM planograma
		WHERE ean = NEW.ean
		AND nro = NEW.nro
		AND num_serie = NEW.num_serie
		AND fabricante = NEW.fabricante;
	IF NEW.unidades > max_units THEN
		RAISE EXCEPTION 'Event units exceeds max allowed by planogram';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_oversupply ON evento_reposicao;
CREATE TRIGGER trigger_oversupply
	BEFORE UPDATE OR INSERT ON evento_reposicao
	FOR EACH ROW EXECUTE PROCEDURE chk_oversupply();

/* RI-5: Um produto só pode ser reposto numa prateleira que apresente (pelo menos) uma das categorias desse produto */
CREATE OR REPLACE FUNCTION chk_presentable() RETURNS TRIGGER AS
$$
BEGIN
	IF NOT EXISTS (
		SELECT nome
		FROM prateleira
		NATURAL JOIN tem_categoria
		WHERE ean = NEW.ean
		AND nro = NEW.nro
		AND num_serie = NEW.num_serie
		AND fabricante = NEW.fabricante
	) THEN
		RAISE EXCEPTION 'Product can only be resupplied onto shelves that allow one of its categories';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_presentable ON evento_reposicao;
CREATE TRIGGER trigger_presentable
	BEFORE UPDATE OR INSERT ON evento_reposicao
	FOR EACH ROW EXECUTE PROCEDURE chk_presentable();

-------------------------------------------
--- Manutenção da Consistência de Dados ---
-------------------------------------------

/* Tem que existir uma relação tem_categoria entre produto.ean e produto.cat */

CREATE OR REPLACE FUNCTION add_cat_rel() RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO tem_categoria(ean, nome) VALUES (NEW.ean, NEW.cat) ON CONFLICT DO NOTHING;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_add_cat_rel ON produto;
CREATE TRIGGER trigger_add_cat_rel
	AFTER UPDATE OR INSERT ON produto
	FOR EACH ROW EXECUTE PROCEDURE add_cat_rel();

/* Quando uma categoria é criada, adicionar às categorias simples */

CREATE OR REPLACE FUNCTION add_new_cat() RETURNS TRIGGER AS
$$
BEGIN
  INSERT INTO categoria_simples(nome) VALUES (NEW.nome);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_add_new_cat ON categoria;
CREATE TRIGGER trigger_add_new_cat
  AFTER UPDATE OR INSERT ON categoria
  FOR EACH ROW EXECUTE PROCEDURE add_new_cat();

/* Quando uma relacao de categoria é criada, promover a super_categoria */

CREATE OR REPLACE FUNCTION promote_cat() RETURNS TRIGGER AS
$$
BEGIN
  DELETE FROM categoria_simples WHERE nome = NEW.super_categoria;
  INSERT INTO super_categoria(nome) VALUES (NEW.super_categoria) ON CONFLICT DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_promote_cat ON tem_outra;
CREATE TRIGGER trigger_promote_cat
  BEFORE UPDATE OR INSERT ON tem_outra
  FOR EACH ROW EXECUTE PROCEDURE promote_cat();

/* Quando a ultima relacao de uma categoria é apagada, despromover a categoria_simples */

CREATE OR REPLACE FUNCTION demote_cat() RETURNS TRIGGER AS
$$
BEGIN
  IF NOT EXISTS (
    SELECT super_categoria
    FROM tem_outra
    WHERE super_categoria = OLD.super_categoria
  ) THEN
    DELETE FROM super_categoria WHERE nome = OLD.super_categoria;
    INSERT INTO categoria_simples(nome) VALUES (OLD.super_categoria);
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_demote_cat ON tem_outra;
CREATE TRIGGER trigger_demote_cat
  AFTER DELETE ON tem_outra
  FOR EACH ROW EXECUTE PROCEDURE demote_cat();

/* Quando uma categoria é apagada, apagar tudo o que depende dela */

CREATE OR REPLACE FUNCTION remove_cat_deps() RETURNS TRIGGER AS
$$
BEGIN
	DELETE FROM produto WHERE cat = OLD.nome;
  DELETE FROM tem_outra WHERE super_categoria = OLD.nome OR categoria = OLD.nome;
	DELETE FROM super_categoria WHERE nome = OLD.nome;
	DELETE FROM categoria_simples WHERE nome = OLD.nome;
  DELETE FROM responsavel_por WHERE nome_cat = OLD.nome;
  DELETE FROM prateleira WHERE nome = OLD.nome;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_cat_deps ON categoria;
CREATE TRIGGER trigger_remove_cat_deps
	BEFORE DELETE ON categoria
	FOR EACH ROW EXECUTE PROCEDURE remove_cat_deps();

/* Quando um produto é apagada, apagar tudo o que depende dela */
CREATE OR REPLACE FUNCTION remove_prod_deps() RETURNS TRIGGER AS
$$
BEGIN
  DELETE FROM planograma WHERE ean = OLD.ean;
  DELETE FROM tem_categoria WHERE ean = OLD.ean;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_prod_deps ON produto;
CREATE TRIGGER trigger_remove_prod_deps
  BEFORE DELETE ON produto
  FOR EACH ROW EXECUTE PROCEDURE remove_prod_deps();

/* Quando um prateleira é apagada, apagar tudo o que depende dela */
CREATE OR REPLACE FUNCTION remove_shelf_deps() RETURNS TRIGGER AS
$$
BEGIN
  DELETE FROM planograma WHERE nro = OLD.nro AND num_serie = OLD.num_serie AND fabricante = OLD.fabricante;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_shelf_deps ON prateleira;
CREATE TRIGGER trigger_remove_shelf_deps
  BEFORE DELETE ON prateleira
  FOR EACH ROW EXECUTE PROCEDURE remove_shelf_deps();

/* Quando um planograma é apagado, apagar tudo o que depende dele */
CREATE OR REPLACE FUNCTION remove_planogram_deps() RETURNS TRIGGER AS
$$
BEGIN
  DELETE FROM evento_reposicao WHERE ean = OLD.ean AND nro = OLD.nro AND num_serie = OLD.num_serie AND fabricante = OLD.fabricante;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_planogram_deps ON planograma;
CREATE TRIGGER trigger_remove_planogram_deps
  BEFORE DELETE ON planograma
  FOR EACH ROW EXECUTE PROCEDURE remove_planogram_deps();

/* Quando um retailer é apagado, apagar tudo o que deptende dele */

CREATE OR REPLACE FUNCTION remove_retailer_deps() RETURNS TRIGGER AS
$$
BEGIN
  DELETE FROM responsavel_por WHERE tin = OLD.tin;
  DELETE FROM evento_reposicao WHERE tin = OLD.tin;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_retailer_deps ON retalhista;
CREATE TRIGGER trigger_remove_retailer_deps
	BEFORE DELETE ON retalhista
	FOR EACH ROW EXECUTE PROCEDURE remove_retailer_deps();
