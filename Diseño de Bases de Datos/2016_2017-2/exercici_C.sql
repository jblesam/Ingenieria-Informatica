--
-- Base de dades: `Clubs_de_futbol`
--
DROP DATABASE IF EXISTS `Clubs_de_futbol`;
CREATE DATABASE IF NOT EXISTS `Clubs_de_futbol` DEFAULT CHARACTER SET UTF8 COLLATE utf8_unicode_ci;
USE `Clubs_de_futbol`;

-- --------------------------------------------------------
-- C1 - Definició de l'estructura 1FN
-- --------------------------------------------------------

DROP TABLE IF EXISTS estadi;

CREATE TABLE estadi (
  ID int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador únic',
  nom varchar(50)    DEFAULT NULL COMMENT 'Indica el nom de l''estadi',
  capacitat int(10) unsigned DEFAULT NULL COMMENT 'Indica la capacitat d''espectadors que té l''estadi',
  adreça varchar(60) DEFAULT NULL COMMENT 'Indica l''adreça de l''estadi',
  cp varchar(10)     DEFAULT NULL COMMENT 'Indica el codi postal',
  ciutat varchar(60) DEFAULT NULL COMMENT 'Indica la ciutat on està ubicat l''estadi',
  equips varchar(1024) DEFAULT NULL COMMENT 'Indica els diferents clubs que juguen a l''estadi',
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Taula que emmagatzema els diferents estadis on juguen els equips';


DROP TABLE IF EXISTS clubs_de_futbol.equip;

CREATE TABLE clubs_de_futbol.equip (
   ID INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT 'Identificador únic d''equip',
   nom VARCHAR(50) COMMENT 'Indica el nom de l''equip',
   fundadors VARCHAR(1024) COMMENT 'Indica el nom dels fundadors del club',
   títols VARCHAR(255) COMMENT 'Indica el títols aconseguits',
   campionat VARCHAR(40) COMMENT 'Indica el campionat en el que juga',
   data_fundació DATE COMMENT 'Indica la data de fundació',
   estadi VARCHAR(255) COMMENT 'Indica el estadi on juga',
   PRIMARY KEY (ID)
) ENGINE = InnoDB COMMENT = 'Taula que emmagatzema els diferents equips' ROW_FORMAT = DEFAULT;

DROP TABLE IF EXISTS clubs_de_futbol.fundador;

CREATE TABLE clubs_de_futbol.fundador (
   ID INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT 'Identificador únic del fundador',
   nom VARCHAR(50) COMMENT 'Indica el nom del fundador',
   equips varchar(1024) DEFAULT NULL COMMENT 'Indica els diferents clubs que juguen a l''estadi',
   títols VARCHAR(255) COMMENT 'Indica el títols aconseguits',
   campionat VARCHAR(40) COMMENT 'Indica el campionat en el que juga',
   data_naixement DATE COMMENT 'Indica la data de naixement del fundador',
   lloc_naixement VARCHAR(60) COMMENT 'Indica la població on va neixer el fundador',
  PRIMARY KEY (ID)
) ENGINE = InnoDB COMMENT = 'Taula que emmagatzema els diferents fundadors i els equips que van fundar' ROW_FORMAT = DEFAULT;

-- ---------------------------------------
-- C2 -- Modificacions a la taula F2N`...`
-- ---------------------------------------

ALTER TABLE estadi DROP column equips;

DROP TABLE IF EXISTS clubs_de_futbol.competició;

CREATE TABLE clubs_de_futbol.competició (
   ID INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT 'Identificador únic de la competició',
   nom VARCHAR(50) COMMENT 'Indica el nom de la competició',
   campionat INT UNSIGNED COMMENT 'Indica la competició a la que pertany, si nul és una categoria principal',
  PRIMARY KEY (ID)
) ENGINE = InnoDB COMMENT = 'Taula que emmagatzema les diferent competicions en les que participen els equips' ROW_FORMAT = DEFAULT;

ALTER TABLE clubs_de_futbol.equip 
  DROP COLUMN fundadors, 
  DROP COLUMN títols, 
  DROP COLUMN campionat, 
  DROP COLUMN estadi,
  ADD COLUMN competició_ID INT UNSIGNED COMMENT 'Indica en quina competició juga',
  ADD COLUMN estadi_ID INT UNSIGNED COMMENT 'Indica quin és el seu estadi',
  ADD CONSTRAINT FK_equip_competició FOREIGN KEY (competició_ID) REFERENCES clubs_de_futbol.competició (ID) ON UPDATE SET NULL ON DELETE SET NULL,
  ADD CONSTRAINT FK_equip_estadi FOREIGN KEY (estadi_ID) REFERENCES clubs_de_futbol.estadi (ID) ON UPDATE SET NULL ON DELETE SET NULL;

ALTER TABLE clubs_de_futbol.fundador 
  COMMENT = 'Taula que emmagatzema els fundadors d''equips de futbol',
  DROP COLUMN equips,
  DROP COLUMN títols,
  DROP COLUMN campionat,
  ADD COLUMN equip_ID INT UNSIGNED COMMENT 'Indica quin equip va fundar',
  ADD COLUMN competició_ID INT UNSIGNED COMMENT 'Indica quina competició ha guanyat',
  ADD CONSTRAINT FK_fundador_equip FOREIGN KEY (equip_ID) REFERENCES clubs_de_futbol.equip (ID) ON UPDATE SET NULL ON DELETE SET NULL,
  ADD CONSTRAINT FK_fundador_competició FOREIGN KEY (competició_ID) REFERENCES clubs_de_futbol.competició (ID) ON UPDATE SET NULL ON DELETE SET NULL;

DROP TABLE IF EXISTS títols_equip;

CREATE TABLE clubs_de_futbol.títols_equip (
   ID INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT 'Identificador únic de la relació',
   equip_ID INT UNSIGNED COMMENT 'Indica l''equip',
   competició_ID INT UNSIGNED COMMENT 'Indica quina competició ha guanyat',
  PRIMARY KEY (ID)
) ENGINE = InnoDB COMMENT = 'Taula que emmagatzema els diferents títols que han guanyat els equips' ROW_FORMAT = DEFAULT;

ALTER TABLE clubs_de_futbol.títols_equip
 ADD CONSTRAINT FK_títols_equip_competició FOREIGN KEY (competició_ID) REFERENCES clubs_de_futbol.competició (ID) ON UPDATE CASCADE ON DELETE CASCADE,
 ADD CONSTRAINT FK_títols_equip_ID FOREIGN KEY (equip_ID) REFERENCES clubs_de_futbol.equip (ID) ON UPDATE CASCADE ON DELETE CASCADE;

DROP TABLE IF EXISTS clubs_de_futbol.títols_fundador;

CREATE TABLE clubs_de_futbol.títols_fundador (
  ID INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT 'Identificador únic de la relació',
  fundador_ID INT UNSIGNED COMMENT 'Indica quin és el fundador que ha guanyat el títol',
  competició_ID INT UNSIGNED COMMENT 'Indica quina competició ha guanyat',
  PRIMARY KEY (ID)
) ENGINE = InnoDB COMMENT = 'Taula que emmagatzema els diferents títols que han guanyat els equips' ROW_FORMAT = DEFAULT;

ALTER TABLE clubs_de_futbol.títols_fundador
 ADD CONSTRAINT FK_títols_fundador_competició FOREIGN KEY (competició_ID) REFERENCES clubs_de_futbol.competició (ID) ON UPDATE CASCADE ON DELETE CASCADE,
 ADD CONSTRAINT FK_títols_fundador_ID FOREIGN KEY (fundador_ID) REFERENCES clubs_de_futbol.fundador (ID) ON UPDATE CASCADE ON DELETE CASCADE;


-- --------------------------------------------------------
-- C2 - Modificació de l'estructura a 3FN
-- --------------------------------------------------------
DROP TABLE IF EXISTS clubs_de_futbol.títols_fundador;

ALTER TABLE clubs_de_futbol.fundador 
  DROP FOREIGN KEY FK_fundador_competició,
  DROP COLUMN competició_ID;

-- --------------------------------------------------------
-- C3 - Inserció de dades
-- --------------------------------------------------------

--
-- Bolcant dades de la taula `...`
--
START TRANSACTION;

insert into competició(ID, nom, campionat) values (1,'LaLiga',null);
insert into competició(ID, nom, campionat) values (2,'Lliga',1);
insert into competició(ID, nom, campionat) values (3,'Copa',1);
insert into competició(ID, nom, campionat) values (4,'Supercopa',1);
insert into competició(ID, nom, campionat) values (5,'Serie A',null);
insert into competició(ID, nom, campionat) values (6,'Coppa',5);
insert into competició(ID, nom, campionat) values (7,'Scudetto',5);
insert into competició(ID, nom, campionat) values (8,'LaLiga 1|2|3',null);

insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (1,'Camp Nou',99354,'Avinguda Aristides Maillol, s/n','08028','Barcelona');
insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (2,'Anoeta',32076,'Anoeta Pasalekua, 1','20014','Donostia');
insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (3,'Santiago Bernabeu',81044,'Avda. de Concha Espina 1,','28036','Madrid');
insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (4,'RCDE Stadium',41000,'Av. del Baix Llobregat, 100','08940','Cornellà de Llobregat');
insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (5,'Giuseppe Meazza',80018,'Piazzale Angelo Moratti','20151','Milano');
insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (6,'Montilivi',10000,'Avinguda de Montilivi, 141','17003','Girona');

insert into equip(ID, nom, data_fundació, competició_ID, estadi_ID) values (1, 'F.C. Barcelona', str_to_date('29/11/1899','%d/%m/%Y'),1,1);
insert into equip(ID, nom, data_fundació, competició_ID, estadi_ID) values (2, 'Reial Societat', str_to_date('07/09/1909','%d/%m/%Y'),1,2);
insert into equip(ID, nom, data_fundació, competició_ID, estadi_ID) values (3, 'Reial Madrid',   str_to_date('06/03/1902','%d/%m/%Y'),1,3);
insert into equip(ID, nom, data_fundació, competició_ID, estadi_ID) values (4, 'R.C.D. Espanyol',str_to_date('13/10/1900','%d/%m/%Y'),1,4);
insert into equip(ID, nom, data_fundació, competició_ID, estadi_ID) values (5, 'A.C. Milan',     str_to_date('16/12/1899','%d/%m/%Y'),5,5);
insert into equip(ID, nom, data_fundació, competició_ID, estadi_ID) values (6, 'Inter Milan',    str_to_date('09/03/1908','%d/%m/%Y'),5,5);
insert into equip(ID, nom, data_fundació, competició_ID, estadi_ID) values (7, 'Girona F.C.',    str_to_date('25/07/1930','%d/%m/%Y'),8,6);

insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (1,'Joan Gamper',                str_to_date('22/11/1877','%d/%m/%Y'),'Winterthur',1);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (2,'Jorge Satrústegui',          str_to_date('01/05/1873','%d/%m/%Y'),'San Sebastià',2);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (3,'Adolfo Meléndez',            str_to_date('02/06/1884','%d/%m/%Y'),'La Corunya',3);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (4,'Joan Padrós i Rubió',        str_to_date('01/12/1869','%d/%m/%Y'),'Barcelona',3);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (5,'Carles Padrós i Rubió',      str_to_date('09/11/1870','%d/%m/%Y'),'Barcelona',3);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (6,'Julián Palacios',            str_to_date('22/08/1880','%d/%m/%Y'),'Madrid',3);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (7,'Àngel Rodríguez Ruiz',       str_to_date('13/10/1879','%d/%m/%Y'),'Barcelona',4);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (8,'Herbert Kilpin ',            str_to_date('24/01/1870','%d/%m/%Y'),'Nottingham',5);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (9,'Alfred Edwards',             str_to_date('12/10/1850','%d/%m/%Y'),'Skyborry',5);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (10,'Giorgio Muggiani',          str_to_date('14/05/1887','%d/%m/%Y'),'Milano',6);
insert into fundador(ID, nom, data_naixement, lloc_naixement, equip_ID) values (11,'Albert de Quintana de León',str_to_date('05/10/1890','%d/%m/%Y'),'Torroella de Montgrí',7);


insert into títols_equip(ID,equip_ID, competició_ID) values (1,1,2);
insert into títols_equip(ID,equip_ID, competició_ID) values (2,1,3);
insert into títols_equip(ID,equip_ID, competició_ID) values (3,1,4);
insert into títols_equip(ID,equip_ID, competició_ID) values (4,2,2);
insert into títols_equip(ID,equip_ID, competició_ID) values (5,2,3);
insert into títols_equip(ID,equip_ID, competició_ID) values (6,3,2);
insert into títols_equip(ID,equip_ID, competició_ID) values (7,3,3);
insert into títols_equip(ID,equip_ID, competició_ID) values (8,3,4);
insert into títols_equip(ID,equip_ID, competició_ID) values (9,4,3);
insert into títols_equip(ID,equip_ID, competició_ID) values (10,5,6);
insert into títols_equip(ID,equip_ID, competició_ID) values (11,5,7);
insert into títols_equip(ID,equip_ID, competició_ID) values (12,6,7);

commit;

