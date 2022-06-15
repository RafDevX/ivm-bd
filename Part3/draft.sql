/* Draft SQL code used to test instructions for Part 2 */
/* used as starting point for Part 3 SQL work */

DROP TABLE IVM CASCADE;
DROP TABLE PointOfRetail CASCADE;
DROP TABLE InstalledAt CASCADE;
DROP TABLE Shelf CASCADE;
DROP TABLE Product CASCADE;
DROP TABLE Planogram CASCADE;
DROP TABLE ReplenishmentEvent CASCADE;
DROP TABLE Retailer CASCADE;
DROP TABLE Category CASCADE;
DROP TABLE SimpleCategory CASCADE;
DROP TABLE SuperCategory CASCADE;
DROP TABLE HasOther CASCADE;
DROP TABLE Has CASCADE;
DROP TABLE ResponsibleFor CASCADE;

CREATE TABLE IF NOT EXISTS IVM (
	serial_number VARCHAR(50) NOT NULL,
	manuf VARCHAR(50) NOT NULL,
	PRIMARY KEY(serial_number, manuf)
);

CREATE TABLE IF NOT EXISTS PointOfRetail (
	address VARCHAR(200) PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS InstalledAt (
	serial_number VARCHAR(50) NOT NULL,
	manuf VARCHAR(50) NOT NULL,
	address VARCHAR(200) NOT NULL,
	nr INT NOT NULL,
	PRIMARY KEY(serial_number, manuf, address),
	CONSTRAINT fk_installed_at_ivm FOREIGN KEY(serial_number, manuf) REFERENCES IVM(serial_number, manuf),
	CONSTRAINT fk_installed_at_por FOREIGN KEY(address) REFERENCES PointOfRetail(address)
);

CREATE TABLE IF NOT EXISTS Category (
	name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS SimpleCategory (
	name VARCHAR(50) PRIMARY KEY,
	CONSTRAINT fk_simplecategory_category FOREIGN KEY(name) REFERENCES Category(name)
);

CREATE TABLE IF NOT EXISTS SuperCategory (
	name VARCHAR(50) PRIMARY KEY,
	CONSTRAINT fk_supercategory_category FOREIGN KEY(name) REFERENCES Category(name)
);

CREATE TABLE IF NOT EXISTS HasOther (
	super_name VARCHAR(50) NOT NULL,
	child_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(super_name, child_name),
	CONSTRAINT fk_has_other_supercategory FOREIGN KEY(super_name) REFERENCES SuperCategory(name),
	CONSTRAINT fk_has_other_category FOREIGN KEY(child_name) REFERENCES Category(name)
);

CREATE TABLE IF NOT EXISTS Shelf (
	serial_number VARCHAR(50) NOT NULL,
	manuf VARCHAR(50) NOT NULL,
	nr INT NOT NULL, 
	height INT NOT NULL,
	name VARCHAR(50) NOT NULL,
	PRIMARY KEY(serial_number, manuf, nr),
	CONSTRAINT fk_shelf_ivm FOREIGN KEY(serial_number, manuf) REFERENCES IVM(serial_number, manuf),
	CONSTRAINT fk_shelf_category FOREIGN KEY(name) REFERENCES Category(name)
);

CREATE TABLE IF NOT EXISTS Product (
	ean CHAR(13) PRIMARY KEY,
	descr VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Has (
	ean CHAR(13) NOT NULL,
	name VARCHAR(50) NOT NULL,
	PRIMARY KEY(ean, name),
	CONSTRAINT fk_has_product FOREIGN KEY(ean) REFERENCES Product(ean),
	CONSTRAINT fk_has_category FOREIGN KEY(name) REFERENCES Category(name)
);

CREATE TABLE IF NOT EXISTS Planogram (
	ean CHAR(13) NOT NULL,
	serial_number VARCHAR(50) NOT NULL,
	manuf VARCHAR(50) NOT NULL,
	nr INT NOT NULL,
	faces INT NOT NULL,
	units INT NOT NULL,
	loc VARCHAR(255),
	PRIMARY KEY(ean, serial_number, manuf, nr),
	CONSTRAINT fk_planogram_product FOREIGN KEY(ean) REFERENCES Product(ean),
	CONSTRAINT fk_planogram_shelf FOREIGN KEY(serial_number, manuf, nr) REFERENCES Shelf(serial_number, manuf, nr)
);

CREATE TABLE IF NOT EXISTS Retailer (
	TIN CHAR(9) PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS ReplenishmentEvent (
	ean CHAR(13) NOT NULL,
	serial_number VARCHAR(50) NOT NULL,
	manuf VARCHAR(50) NOT NULL,
	instant TIMESTAMP NOT NULL,
	units INT NOT NULL,
	TIN CHAR(9) NOT NULL,
	nr INT NOT NULL,
	PRIMARY KEY(ean, serial_number, manuf, nr, instant),
	CONSTRAINT fk_replenishmentevent_planogram FOREIGN KEY(ean, serial_number, manuf, nr) REFERENCES Planogram(ean, serial_number, manuf, nr),
	CONSTRAINT fk_replenishmentevent_retailer FOREIGN KEY(TIN) REFERENCES Retailer(TIN)
);


CREATE TABLE IF NOT EXISTS ResponsibleFor (
	TIN CHAR(9) NOT NULL,
	serial_number VARCHAR(50) NOT NULL,
	manuf VARCHAR(50) NOT NULL,
	name VARCHAR(50) NOT NULL,
	PRIMARY KEY(TIN, serial_number, manuf, name),
	CONSTRAINT fk_responsible_for_retailer FOREIGN KEY(TIN) REFERENCES Retailer(TIN),
	CONSTRAINT fk_responsible_for_ivm FOREIGN KEY(serial_number, manuf) REFERENCES IVM(serial_number, manuf),
	CONSTRAINT fk_responsible_for_category FOREIGN KEY(name) REFERENCES Category(name)
);

INSERT INTO IVM(serial_number, manuf) VALUES ('ABCD', 'aldi');
INSERT INTO IVM(serial_number, manuf) VALUES ('1234', 'aldi');
INSERT INTO IVM(serial_number, manuf) VALUES ('ABCD', 'lidl');

INSERT INTO PointOfRetail(address, name) VALUES ('R. Santo António 3', 'Galp Oeiras');

INSERT INTO InstalledAt(serial_number, manuf, address, nr) VALUES ('ABCD', 'aldi', 'R. Santo António 3', 1);
INSERT INTO InstalledAt(serial_number, manuf, address, nr) VALUES ('1234', 'aldi', 'R. Santo António 3', 1);
INSERT INTO InstalledAt(serial_number, manuf, address, nr) VALUES ('ABCD', 'lidl', 'R. Santo António 3', 1);

INSERT INTO Category(name) VALUES ('Bebidas');
INSERT INTO Category(name) VALUES ('Barras Energéticas');
INSERT INTO Category(name) VALUES ('Comidas');
INSERT INTO Category(name) VALUES ('Doces');
INSERT INTO Category(name) VALUES ('Saudável');

INSERT INTO SimpleCategory(name) VALUES ('Bebidas');
INSERT INTO SimpleCategory(name) VALUES ('Barras Energéticas');
INSERT INTO SimpleCategory(name) VALUES ('Doces');
INSERT INTO SimpleCategory(name) VALUES ('Saudável');

INSERT INTO SuperCategory(name) VALUES ('Comidas');

INSERT INTO HasOther(super_name, child_name) VALUES ('Comidas', 'Barras Energéticas');
INSERT INTO HasOther(super_name, child_name) VALUES ('Comidas', 'Doces');

INSERT INTO Shelf(serial_number, manuf, nr, height, name) VALUES ('ABCD', 'aldi', 1, 120, 'Bebidas');
INSERT INTO Shelf(serial_number, manuf, nr, height, name) VALUES ('ABCD', 'aldi', 2, 220, 'Bebidas');
INSERT INTO Shelf(serial_number, manuf, nr, height, name) VALUES ('ABCD', 'lidl', 1, 100, 'Barras Energéticas');
INSERT INTO Shelf(serial_number, manuf, nr, height, name) VALUES ('1234', 'aldi', 1, 300, 'Barras Energéticas');
INSERT INTO Shelf(serial_number, manuf, nr, height, name) VALUES ('1234', 'aldi', 3, 120, 'Bebidas');

INSERT INTO Product(ean, descr) VALUES ('9002490100070', 'Ice Tea');
INSERT INTO Product(ean, descr) VALUES ('9002490100123', 'Água');
INSERT INTO Product(ean, descr) VALUES ('9002490100456', 'Oreos');
INSERT INTO Product(ean, descr) VALUES ('9002490100789', 'Barritas');

INSERT INTO Has(ean, name) VALUES ('9002490100070', 'Bebidas'); 
INSERT INTO Has(ean, name) VALUES ('9002490100123', 'Bebidas'); 
INSERT INTO Has(ean, name) VALUES ('9002490100123', 'Saudável'); 
INSERT INTO Has(ean, name) VALUES ('9002490100456', 'Doces'); 
INSERT INTO Has(ean, name) VALUES ('9002490100789', 'Barras Energéticas');
INSERT INTO Has(ean, name) VALUES ('9002490100789', 'Saudável');

INSERT INTO Planogram(ean, serial_number, manuf, nr, faces, units, loc) VALUES ('9002490100070', 'ABCD', 'aldi', 1, 5, 10, '??');
INSERT INTO Planogram(ean, serial_number, manuf, nr, faces, units, loc) VALUES ('9002490100070', 'ABCD', 'aldi', 2, 6, 12, '??');
INSERT INTO Planogram(ean, serial_number, manuf, nr, faces, units, loc) VALUES ('9002490100123', 'ABCD', 'aldi', 1, 5, 12, '??');
INSERT INTO Planogram(ean, serial_number, manuf, nr, faces, units, loc) VALUES ('9002490100123', 'ABCD', 'lidl', 1, 6, 10, '??');
INSERT INTO Planogram(ean, serial_number, manuf, nr, faces, units, loc) VALUES ('9002490100789', '1234', 'aldi', 1, 3, 23, '??');

INSERT INTO Retailer(TIN, name) VALUES ('500123456', 'Galp');
INSERT INTO Retailer(TIN, name) VALUES ('500789012', 'Repsol');
INSERT INTO Retailer(TIN, name) VALUES ('500345678', 'Shell');

INSERT INTO ReplenishmentEvent(ean, serial_number, manuf, nr, instant, units, TIN) VALUES ('9002490100070', 'ABCD', 'aldi', 1, '2020-06-14T15:24:21Z', 15, '500123456');
INSERT INTO ReplenishmentEvent(ean, serial_number, manuf, nr, instant, units, TIN) VALUES ('9002490100070', 'ABCD', 'aldi', 1, '2020-07-13T12:04:41Z', 1, '500123456');
INSERT INTO ReplenishmentEvent(ean, serial_number, manuf, nr, instant, units, TIN) VALUES ('9002490100070', 'ABCD', 'aldi', 1, '2021-02-11T19:04:21Z', 4, '500123456');
INSERT INTO ReplenishmentEvent(ean, serial_number, manuf, nr, instant, units, TIN) VALUES ('9002490100123', 'ABCD', 'lidl', 1, '2022-03-13T08:09:12Z', 2, '500345678');
INSERT INTO ReplenishmentEvent(ean, serial_number, manuf, nr, instant, units, TIN) VALUES ('9002490100123', 'ABCD', 'lidl', 1, '2022-03-13T08:09:13Z', 23, '500345678');
INSERT INTO ReplenishmentEvent(ean, serial_number, manuf, nr, instant, units, TIN) VALUES ('9002490100789', '1234', 'aldi', 1, '2022-03-13T08:09:13Z', 12, '500345678');
INSERT INTO ReplenishmentEvent(ean, serial_number, manuf, nr, instant, units, TIN) VALUES ('9002490100789', '1234', 'aldi', 1, '2022-03-13T08:09:24Z', 13, '500345678');
/* ... add more ... */

INSERT INTO ResponsibleFor(TIN, serial_number, manuf, name) VALUES ('500123456', 'ABCD', 'aldi', 'Bebidas');
INSERT INTO ResponsibleFor(TIN, serial_number, manuf, name) VALUES ('500345678', 'ABCD', 'lidl', 'Saudável');
