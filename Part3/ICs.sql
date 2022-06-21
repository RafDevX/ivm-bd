/* O número de unidades repostas  num evento de reposição não pode exceder o número de unidades especificado no planograma */
CREATE OR REPLACE FUNCTION chk_oversupply() RETURNS TRIGGER AS
$$
DECLARE max_units INTEGER;
BEGIN
	SELECT unidades INTO max_units
		FROM planograma
		WHERE ean = NEW.ean
		AND nro = NEW.nro
		AND num_serie = NEW.num_serie,
		AND fabricante = NEW.fabricante;
	IF NEW.unidades > max_units THEN
		RAISE EXCEPTION 'Event units exceeds max allowed by planogram';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER trigger_oversupply ON evento_reposicao IF EXISTS;
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

DROP TRIGGER trigger_presentable ON evento_reposicao IF EXISTS;
CREATE TRIGGER trigger_presentable
	BEFORE UPDATE OR INSERT ON evento_reposicao
	FOR EACH ROW EXECUTE PROCEDURE chk_presentable();
