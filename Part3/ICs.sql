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

/* Quando uma categoria é apagada, apagar tudo o que depende dela */

CREATE OR REPLACE FUNCTION remove_cat_deps() RETURNS TRIGGER AS
$$
BEGIN
	DELETE FROM produto WHERE cat = OLD.nome;
	/* TODO: continue... */
	
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_cat_deps ON categoria;
CREATE TRIGGER trigger_remove_cat_deps
	BEFORE DELETE ON categoria
	FOR EACH ROW EXECUTE PROCEDURE remove_cat_deps();
