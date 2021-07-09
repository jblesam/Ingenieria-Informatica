DROP TABLE IF EXISTS clubs_de_futbol.fundador_equip;

CREATE TABLE clubs_de_futbol.fundador_equip (
   ID INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT 'Identificador únic de la relació',
   fundador_ID INT UNSIGNED COMMENT 'Indica el fundador de l''equip',   
   equip_ID INT UNSIGNED COMMENT 'Indica l''equip',
   PRIMARY KEY (ID)
) ENGINE = InnoDB COMMENT = 'Taula que emmagatzema els fundadors i els equips fundats' ROW_FORMAT = DEFAULT;

ALTER TABLE clubs_de_futbol.fundador_equip
 ADD CONSTRAINT FK_fundador_equip_ID FOREIGN KEY (fundador_ID) REFERENCES clubs_de_futbol.fundador (ID) ON UPDATE CASCADE ON DELETE CASCADE,
 ADD CONSTRAINT FK_títols_fundador_equip_ID FOREIGN KEY (equip_ID) REFERENCES clubs_de_futbol.equip (ID) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE clubs_de_futbol.fundador
 DROP FOREIGN KEY FK_fundador_equip,
 DROP equip_ID; 
 
insert into fundador_equip(ID,fundador_ID, equip_ID) values (1,1,1);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (2,2,2);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (3,3,3);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (4,4,3);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (5,5,3);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (6,6,3);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (7,7,4);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (8,8,5);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (9,9,5);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (10,10,6);
insert into fundador_equip(ID,fundador_ID, equip_ID) values (11,11,7);


