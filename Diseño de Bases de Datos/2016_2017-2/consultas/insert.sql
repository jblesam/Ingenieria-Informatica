DROP DATABASE IF EXISTS `Clubs_de_futbol`;
CREATE DATABASE IF NOT EXISTS `Clubs_de_futbol` DEFAULT CHARACTER SET UTF8 COLLATE utf8_unicode_ci;
USE `Clubs_de_futbol`;

insert into competició(ID, nom, campionat) values (1,'LaLiga',null);
insert into competició(ID, nom, campionat) values (2,'Lliga',1);
insert into competició(ID, nom, campionat) values (3,'Copa',1);
insert into competició(ID, nom, campionat) values (4,'Supercopa',1);
insert into competició(ID, nom, campionat) values (5,'Serie A',null);
insert into competició(ID, nom, campionat) values (6,'Coppa',5);
insert into competició(ID, nom, campionat) values (7,'Scudetto',5);
insert into competició(ID, nom, campionat) values (8,'LaLiga 1|2|3',null);

insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (1,'Camp Nou',99354,'Avinguda Aristides Maillol, s/n,','08028','Barcelona');
insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (2,'Anoeta',32076,'Anoeta Pasalekua, 1','20014','Donostia');
insert into estadi(ID, nom, capacitat, adreça, cp, ciutat) values (3,'Santiago Berbabeu',81044,'Avda. de Concha Espina 1,','28036','Madrid');
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


insert into títols(ID,equip_ID, competició_ID) values (1,1,2);
insert into títols(ID,equip_ID, competició_ID) values (2,1,3);
insert into títols(ID,equip_ID, competició_ID) values (3,1,4);
insert into títols(ID,equip_ID, competició_ID) values (4,2,2);
insert into títols(ID,equip_ID, competició_ID) values (5,2,3);
insert into títols(ID,equip_ID, competició_ID) values (6,3,2);
insert into títols(ID,equip_ID, competició_ID) values (7,3,3);
insert into títols(ID,equip_ID, competició_ID) values (8,3,4);
insert into títols(ID,equip_ID, competició_ID) values (9,4,3);
insert into títols(ID,equip_ID, competició_ID) values (10,5,6);
insert into títols(ID,equip_ID, competició_ID) values (11,5,7);
insert into títols(ID,equip_ID, competició_ID) values (12,6,7);



select e.*, GROUP_CONCAT(f.nom SEPARATOR ',') from fundador f, equip e
where f.equip_ID = e.ID
group by e.ID


select e.nom, GROUP_CONCAT(c.nom SEPARATOR ',') as títols, cc.nom as competició
from 
equip e LEFT JOIN títols t ON (t.equip_ID = e.ID) 
        LEFT JOIN competició c ON c.ID = t.competició_ID
        JOIN competició cc ON (cc.ID = e.competició_ID)
GROUP BY e.ID;

