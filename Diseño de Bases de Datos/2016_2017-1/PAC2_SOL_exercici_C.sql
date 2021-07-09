--
-- Base de dades: `Assignatures`
--
-- DROP DATABASE IF EXISTS `Assignatures`;
-- CREATE DATABASE IF NOT EXISTS `Assignatures` DEFAULT CHARACTER SET UTF8 COLLATE utf8_unicode_ci;
-- USE `Assignatures`;

-- --------------------------------------------------------
-- C1 - Definició de l'estructura 1FN
-- --------------------------------------------------------

--
-- Estructura de la taula `Assignatura`
--

DROP TABLE IF EXISTS `Assignatura`;
CREATE TABLE `Assignatura` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `professor` varchar(100) NOT NULL,
  `àrea` varchar(50) NOT NULL,
  `tipus` varchar(20) NOT NULL,
  `aula` varchar(10) NOT NULL,
  `edifici` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Professor`
--

DROP TABLE IF EXISTS `Professor`;
CREATE TABLE `Professor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(20) NOT NULL,
  `cognoms` varchar(20) NOT NULL,
  `especialitat` varchar(50) NOT NULL,
  `telèfon` varchar(9) NOT NULL,
  `aniversari` date NOT NULL,
  `adreça` varchar(100) NOT NULL,
  `CP` varchar(5) NOT NULL,
  `ciutat` varchar(50) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Edifici`
--

DROP TABLE IF EXISTS `Edifici`;
CREATE TABLE `Edifici` ( 
	`id` INT NOT NULL AUTO_INCREMENT,
	`nom` VARCHAR(10) NOT NULL,
	`director` VARCHAR(100) NOT NULL,
	`adreça` VARCHAR(100) NOT NULL,
	`cp` VARCHAR(5) NOT NULL,
	`ciutat` VARCHAR(20) NOT NULL,
	`aula` VARCHAR(10) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- C2 - Modificació de l'estructura a 3FN
-- --------------------------------------------------------

--
-- Modificacions a la taula `Assignatura`
--

ALTER TABLE `Assignatura`
  DROP `professor`,
  DROP `àrea`,
  DROP `edifici`,
  CHANGE `tipus` `tipus` INT NOT NULL,
  CHANGE `aula` `aula` INT NOT NULL;

--
-- Modificacions a la taula `Professor`
--

ALTER TABLE `Professor`
  DROP `especialitat`,
  CHANGE `ciutat` `ciutat` INT NOT NULL;

--
-- Modificacions a la taula `Edifici`
--

ALTER TABLE `Edifici`
  DROP `aula`,
  CHANGE `director` `director` INT NOT NULL,
  CHANGE `ciutat` `ciutat` INT NOT NULL;

--
-- Estructura de la taula `Tipus`
--

DROP TABLE IF EXISTS `Tipus`;
CREATE TABLE `Tipus` ( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Aula`
--

DROP TABLE IF EXISTS `Aula`;
CREATE TABLE `Aula` ( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `aula` VARCHAR(20) NOT NULL,
  `edifici_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (edifici_id) REFERENCES Edifici(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Ciutat`
--

DROP TABLE IF EXISTS `Ciutat`;
CREATE TABLE `Ciutat` ( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Especialitat`
--

DROP TABLE IF EXISTS `Especialitat`;
CREATE TABLE `Especialitat` ( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Saber`
--

DROP TABLE IF EXISTS `Saber`;
CREATE TABLE `Saber` ( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `professor_id` INT NOT NULL,
  `especialitat_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (professor_id) REFERENCES Professor(Id),
  FOREIGN KEY (especialitat_id) REFERENCES Especialitat(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Pertànyer`
--

DROP TABLE IF EXISTS `Pertànyer`;
CREATE TABLE `Pertànyer` ( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `assignatura_id` INT NOT NULL,
  `especialitat_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (assignatura_id) REFERENCES Assignatura(Id),
  FOREIGN KEY (especialitat_id) REFERENCES Especialitat(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Estructura de la taula `Impartir`
--

DROP TABLE IF EXISTS `Impartir`;
CREATE TABLE `Impartir` ( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `assignatura_id` INT NOT NULL,
  `professor_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (assignatura_id) REFERENCES Assignatura(Id),
  FOREIGN KEY (professor_id) REFERENCES Professor(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- C3 - Inserció de dades
-- --------------------------------------------------------

--
-- Bolcant dades de la taula `Assignatura`
--

INSERT INTO Assignatura VALUES 
(1,'Disseny de Bases de Dades',1,1),
(2,'Àlgebra Lineal',2,8),
(3,'Música',2,5),
(4,'Anglès - Nivell 2',2,10),
(5,'Història de l’Art',3,3),
(6,'Història',2,6),
(7,'Educació Social',1,11),
(8,'Disseny',3,7),
(9,'Geografia',2,11),
(10,'Biologia',2,2),
(11,'Anglès - Nivell 1',2,7);

--
-- Bolcant dades de la taula `Professor`
--

INSERT INTO Professor VALUES
(1,'Joan','Amorós','625678991',STR_TO_DATE('30/8/78', '%d/%m/%y'),'Avinguda Diagonal 634','91556',1),
(2,'Manuel','Cruz','676564738',STR_TO_DATE('18/1/74', '%d/%m/%y'),'Carrer del Mig 22','8840',2),
(3,'Alberto','Moreno','620087387',STR_TO_DATE('19/3/83', '%d/%m/%y'),'Avinguda del Nord 33','8585',3),
(4,'Xavier','Molina','690253463',STR_TO_DATE('10/9/77', '%d/%m/%y'),'Carrer Tordera 23','8081',4),
(5,'José Luís','Núñez','657002322',STR_TO_DATE('23/4/75', '%d/%m/%y'),'Plaça de la Seu 1','8092',5),
(6,'Raúl','Vázquez','677566767',STR_TO_DATE('13/9/79', '%d/%m/%y'),'Avinguda del Riu 102','8031',6),
(7,'Emilio','Martín','655923431',STR_TO_DATE('18/2/81', '%d/%m/%y'),'Carrer de la Rivera 2','26077',7),
(8,'Carme','Martínez','608567783',STR_TO_DATE('13/9/79', '%d/%m/%y'),'Avinguda de la Creu 15','8028',8),
(9,'Núria','Dot','677486965',STR_TO_DATE('24/4/71', '%d/%m/%y'),'Gran Vía 334','8199',9),
(10,'Sandra','Jans','690817564',STR_TO_DATE('7/4/83', '%d/%m/%y'),'Parc Central 5','8540',10),
(11,'Rebeca','Martín','697352443',STR_TO_DATE('3/7/64', '%d/%m/%y'),'Avenida de la Santa Cruz, 1','8590',11),
(12,'Raquel','Mateos','685676009',STR_TO_DATE('20/12/82', '%d/%m/%y'),'Carrer del Bisbe 31','8208',12),
(13,'Alberto','Vázquez','690886058',STR_TO_DATE('2/8/77', '%d/%m/%y'),'Carrer de Can Ametller 24','8776',13);


--
-- Bolcant dades de la taula `Edifici`
--

INSERT INTO Edifici VALUES 
(1,'Edifici A',10,'Rambla del Poblenou, 156','8035',14),
(2,'Edifici B',13,'Rambla del Poblenou, 160','8035',14),
(3,'Edifici C',1,'Avinguda del Tibidabo, 39','8035',14),
(4,'Edifici D',6,'Av. Carl Friedrich Gauss, 5','8035',15);

--
-- Bolcant dades de la taula `Tipus`
--

INSERT INTO Tipus VALUES 
(1, 'Opcional'),
(2, 'Obligatòria'),
(3, 'Optativa');

--
-- Bolcant dades de la taula `Especialitat`
--

INSERT INTO Especialitat VALUES 
(1, 'Ciència i Tecnologia'),
(2, 'Humanitats'),
(3, 'Arts');

--
-- Bolcant dades de la taula `Aula`
--

INSERT INTO Aula VALUES
(1,'A-101',1),
(2,'A-209',1),
(3,'A-213',1),
(4,'A-304',1),
(5,'B-120',2),
(6,'B-215',2),
(7,'B-302',2),
(8,'B-305',2),
(9,'B-310',2),
(10,'C-101',3),
(11,'C-205',3),
(12,'C-301',3),
(13,'C-410',3),
(14,'D-101',4),
(15,'D-201',4),
(16,'D-301',4);

--
-- Bolcant dades de la taula `Ciutat`
--

INSERT INTO Ciutat VALUES
(1,'Sabadell'),
(2,'Bellaterra'),
(3,'L’Hospitalet'),
(4,'Tarragona'),
(5,'Lleida'),
(6,'Girona'),
(7,'Castelló'),
(8,'Menorca'),
(9,'Zaragoza'),
(10,'El Prat de Llobregat'),
(11,'Sevilla'),
(12,'Salt'),
(13,'Sant Cugat'),
(14,'Barcelona'),
(15,'Castelldefels');

--
-- Bolcant dades de la taula `Impartir`
--

INSERT INTO Impartir VALUES
(1,1,1),
(2,2,2),
(3,2,3),
(4,3,4),
(5,4,1),
(6,5,5),
(7,5,6),
(8,6,7),
(9,6,8),
(10,7,9),
(11,7,2),
(12,7,9),
(13,7,10),
(14,8,10),
(15,9,11),
(16,10,12),
(17,11,13);

--
-- Bolcant dades de la taula `Pertànyer`
--

INSERT INTO Pertànyer VALUES
(1,1,1),
(2,2,1),
(3,3,3),
(4,4,2),
(5,5,3),
(6,6,2),
(7,7,2),
(8,8,1),
(9,8,2),
(10,8,3),
(11,9,1),
(12,10,1),
(13,11,2);

--
-- Bolcant dades de la taula `Saber`
--

INSERT INTO Saber VALUES
(1,1,1),
(2,1,2),
(3,1,3),
(4,2,1),
(5,2,2),
(6,3,1),
(7,4,2),
(8,5,3),
(9,6,3),
(10,6,2),
(11,7,3),
(12,8,1),
(13,8,3),
(14,9,1),
(15,10,1),
(16,11,3),
(17,11,1),
(18,12,2),
(19,12,1),
(20,13,2);