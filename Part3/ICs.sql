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

