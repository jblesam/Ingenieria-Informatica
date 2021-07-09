#-----------------
#-- Exercici  1 --
#-----------------
# Presenteu un llistat, ordenat de forma descendent per l’any de la seva formació, dels grups registrats a la base de dades. Mostreu-ne només el nom i seu email. Mostreu només els 30 primers registres obtinguts.

SELECT nom, email
FROM grup
ORDER BY any_formació DESC
LIMIT 30;

#-----------------
#-- Exercici  2 --
#-----------------
# Presenteu un llistat de tots els discs enregistrats abans del 1995 ordenats alfabèticament pel seu nom de forma descendent.

SELECT * 
FROM disc 
WHERE any_publicació <1995
ORDER BY nom DESC;

#-----------------
#-- Exercici  3 --
#-----------------
# Presenteu un llistat dels discos publicats anteriorment al 1995 i el nom i aforament dels locals on es van presentar ordenats alfabèticament de forma ascendent pel nom del local.

SELECT d.nom disc, l.nom local, l.aforament
FROM disc d
LEFT JOIN local l ON l.id = d.local_ID
WHERE any_publicació <1995
ORDER BY LOCAL ASC;

#-----------------
#-- Exercici  4 --
#-----------------
# Presenteu un llistat dels locals enregistrats a la base de dades on es mostri el nom, l’assistència mitjana als concerts que allà s’han realitzat i quin és el màxim número d’assistents a un concert.

SELECT l.nom, AVG(i.assistents) assistents, MAX(i.assistents) màxim
FROM local l
LEFT JOIN interpretar i ON l.ID = i.local_ID
GROUP BY i.local_ID;

#-----------------
#-- Exercici  5 --
#-----------------
# Modifiqueu la consulta anterior per tal de mostrar el nom del grup corresponent al concert que ha tingut la màxima assistència.

SELECT b4.nom local, b4.assistents, b4.màxim, g.nom grup
FROM (
  SELECT l.nom, AVG(i.assistents) assistents, MAX(i.assistents) màxim
  FROM LOCAL l
  LEFT JOIN interpretar i ON l.ID = i.local_ID
  GROUP BY i.local_ID
) b4
INNER JOIN interpretar i ON i.assistents = b4.màxim
INNER JOIN grup g ON g.id = i.grup_ID;

#-----------------
#-- Exercici  6 --
#-----------------
# Presenteu un llistat de cançons publicades entre el 2010 i el 2012 i el nom del disc al que pertanyen sempre i quan el local on va ser presentada la cançó tingui un aforament inferior a les 500 persones, ordenat de forma ascendent segons l’any de publicació del disc i descendent segons la duració de les cançons. 

SELECT c.id, c.nom, c.duració, d.nom
FROM cançó c
LEft join enregistrar e on e.cançó_ID = c.id
LEFt join disc d on d.id = e.disc_ID
left join local l on l.id = d.local_id
WHERE d.any_publicació BETWEEN 2010 AND 2012 AND l.aforament < 500
ORDER BY d.any_publicació ASC, c.duració DESC;

#----------------
#-- Exercici  7 --
#----------------
# Presenteu un llistat de tots els grups que hagin enregistrat un únic disc entre el 2001 i el 2003 sempre i quan no hagi estat aquest el seu disc de debut.

SELECT g.ID, g.nom, g.any_formació
FROM grup g
LEFT JOIN enregistrar e ON g.ID = e.grup_ID
LEFT JOIN disc d ON e.disc_ID = d.ID
LEFT JOIN (
    SELECT g.ID grup, MIN(d.any_publicació) min 
    FROM grup g 
    LEFT JOIN enregistrar e ON g.ID = e.grup_ID 
    LEFT JOIN disc d ON e.disc_ID = d.ID 
    GROUP BY g.ID
    ) AS mindisc ON mindisc.grup = g.ID
WHERE d.any_publicació >= 2001 and d.any_publicació <= 2003 and d.any_publicació <> mindisc.min
GROUP BY g.ID
HAVING COUNT( distinct e.disc_ID ) = 1;

#-----------------
#-- Exercici  8 --
#-----------------
# Presenteu un llistat dels discos publicats a la sala Barts. En el cas que tinguin una cançó gravada en concert, mostreu el nom del disc en majúscules i, en cas contrari, en minúscules. Mostreu, a més, el total de cançons que conté i la seva duració.

SELECT d.ID, 
CASE WHEN e.en_concert ='Sí'	
	THEN UPPER (d.nom) 	
	ELSE LOWER (d.nom) 
END nom, 
SUM( c.duració ) duració, COUNT( distinct c.ID ) cançons
FROM disc d
INNER JOIN enregistrar e ON e.disc_ID = d.ID
INNER JOIN cançó c ON c.id = e.cançó_ID
INNER JOIN local l ON d.local_ID = l.ID
WHERE l.nom = 'Barts'
GROUP BY d.ID, e.en_concert;

#-----------------
#-- Exercici  9 --
#-----------------
# Presenteu un llistat de grups amb quatre discos i els grups amb més de vuit discos. Ordeneu els grups de forma descendent segons l’any de formació.

SELECT g.id, g.nom, g.email, g.any_formació, count(distinct d.ID) discos
FROM grup g
LEFT JOIN enregistrar e ON e.grup_ID = g.id
LEFT JOIN disc d ON d.id = e.disc_ID
GROUP BY g.id
HAVING discos = 4 OR discos > 8
ORDER BY g.any_formació desc;

#-----------------
#-- Exercici 10 --
#-----------------
# S’ha detectat que la cançó “Radio Bemba” ha estat assignada al disc “Vigila” del grup La Gossa Sorda, en comptes del disc “Radio Bemba Sound System” de Manu Chao. Indiqueu la consulta necessària per tal d’actualitzar la base de dades i corregir aquest error.

UPDATE enregistrar e 
LEFT JOIN cançó c ON c.ID = e.cançó_ID
SET 
e.grup_ID = ( 	
	SELECT g.id
	FROM grup g	WHERE UPPER (g.nom) = UPPER('Manu Chao') ),
e.disc_ID = (
	SELECT d.id
	FROM disc d
	WHERE UPPER (d.nom) = UPPER('Radio Bemba Sound System'))
WHERE UPPER (c.nom) = UPPER('Radio Bemba');

