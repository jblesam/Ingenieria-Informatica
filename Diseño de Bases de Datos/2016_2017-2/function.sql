DROP FUNCTION IF EXISTS checkUser;

DELIMITER $$
CREATE FUNCTION checkUser (email CHAR(50), contrasenya CHAR(40)) 
 RETURNS INT 
BEGIN
  insert into accessos(conductor_dni)
   select c.DNI FROM conductor c where c.email = email and c.contrasenya = contrasenya;
  RETURN ROW_COUNT();
END;
$$

DELIMITER ;

ALTER TABLE conductor 
ADD COLUMN email VARCHAR(50),
ADD COLUMN contrasenya VARCHAR(40);

DROP TABLE IF EXISTS accessos;

CREATE TABLE `accessos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `data_accés` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Emmagatzema l''hora d''accés',
  `conductor_dni` varchar(20) NOT NULL COMMENT 'Emmagatzema el ID del conductor',
  PRIMARY KEY (`ID`),
  KEY `FK_ACCESOS_CONDUCTOR` (`conductor_dni`),
  CONSTRAINT `FK_ACCESOS_CONDUCTOR` FOREIGN KEY (`conductor_dni`) REFERENCES `conductor` (`DNI`)
) ENGINE=InnoDB COMMENT='Taula que emmagatzema els accessos dels conductors';

update conductor set email = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
lower(concat(substr(nom,1,1),cognoms,'@uoc.com'))
,'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u'),'à','a'),'è','e'),'ì','i'),'ò','o'),'ù','u'),contrasenya = MD5('12345');

ALTER TABLE ruta
 CHANGE codi_ruta ID INT(11) AUTO_INCREMENT NOT NULL;

ALTER TABLE transport
 DROP FOREIGN KEY transport_ibfk_1,
 DROP FOREIGN KEY transport_ibfk_2;

ALTER TABLE transport DROP INDEX matrícula;
ALTER TABLE transport DROP INDEX codi_ruta;

ALTER TABLE transport
 ADD ID INT KEY AUTO_INCREMENT FIRST,
 CHANGE matrícula camió_matrícula VARCHAR(10),
 CHANGE codi_ruta ruta_ID INT(11);

ALTER TABLE transport
 ADD CONSTRAINT transport_ibfk_1 FOREIGN KEY (camió_matrícula) REFERENCES camió (matrícula) ON UPDATE RESTRICT ON DELETE RESTRICT,
 ADD CONSTRAINT transport_ibfk_2 FOREIGN KEY (ruta_ID) REFERENCES ruta (ID) ON UPDATE RESTRICT ON DELETE RESTRICT;



/*
select * from conductor;

select checkUser('jmuntada@uoc.com','827ccb0eea8a706c4c34a16891f84e7b') from dual;

                                827ccb0eea8a706c4c34a16891f84e7b
select MD5('12345') from dual;

*/