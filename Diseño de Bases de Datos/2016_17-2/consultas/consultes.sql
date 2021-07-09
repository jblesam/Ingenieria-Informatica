-- Taula EQUIPS
select e.nom, 
(select GROUP_CONCAT(nom SEPARATOR ',') from fundador where equip_ID = e.ID) as fundadors, 
GROUP_CONCAT(c.nom SEPARATOR ',') as campionats, cc.nom as lliga, 
DATE_FORMAT(e.data_fundació, '%d/%m/%Y') as fundació, 
(select nom from estadi where ID = e.estadi_ID) as estadi
from 
equip e LEFT JOIN títols_equip t ON (t.equip_ID = e.ID) 
        LEFT JOIN competició c ON c.ID = t.competició_ID
        JOIN competició cc ON (cc.ID = e.competició_ID)
 GROUP BY e.ID;

-- Taula FUNDADORS
select f.nom, e.nom as equips, GROUP_CONCAT(c.nom SEPARATOR ',') as campionats, cc.nom as lliga,
CONCAT(DATE_FORMAT(f.data_naixement, '%d de %b de %Y'),', ', f.lloc_naixement) as naixement
from fundador f JOIN equip e ON e.ID = f.equip_ID
LEFT JOIN títols_equip t ON (t.equip_ID = e.ID) 
        LEFT JOIN competició c ON c.ID = t.competició_ID
        JOIN competició cc ON (cc.ID = e.competició_ID)
GROUP BY f.ID;

-- Taula ESTADI
select s.nom, REPLACE(FORMAT(s.capacitat,0),',','.') as capacitat, concat(s.adreça,', ' ,s.cp,', ' , s.ciutat) as adreça, GROUP_CONCAT(e.nom SEPARATOR ',') as equips
from estadi s JOIN equip e ON e.estadi_ID = s.ID
group by s.ID;

-- Taules F1N


-- Taula EQUIP
select @rownum:=@rownum+1 AS ID, e.nom, f.nom as fundador, c.nom as títol, cc.nom as campionat, 
DATE_FORMAT(e.data_fundació, '%d/%m/%Y') as data_fundació, 
(select nom from estadi where ID = e.estadi_ID) as estadi
from (SELECT @rownum:=0) r,
equip e JOIN fundador f ON (f.equip_ID = e.ID)
        LEFT JOIN títols_equip t ON (t.equip_ID = e.ID) 
        LEFT JOIN competició c ON c.ID = t.competició_ID
        JOIN competició cc ON (cc.ID = e.competició_ID);

-- Taula FUNDADOR
select @rownum:=@rownum+1 AS ID, f.nom, e.nom as equips, c.nom as títols, cc.nom as campionat,
DATE_FORMAT(f.data_naixement, '%d/%m/%Y') as data_naixement,f.lloc_naixement
from (SELECT @rownum:=0) r, fundador f JOIN equip e ON e.ID = f.equip_ID
LEFT JOIN títols_equip t ON (t.equip_ID = e.ID) 
        LEFT JOIN competició c ON c.ID = t.competició_ID
        JOIN competició cc ON (cc.ID = e.competició_ID);

-- Taula ESTADI
select @rownum:=@rownum+1 AS ID,s.nom, REPLACE(FORMAT(s.capacitat,0),',','.') as capacitat, 
s.adreça,s.cp,s.ciutat, 
e.nom as equip
from (SELECT @rownum:=0) r, estadi s JOIN equip e ON e.estadi_ID = s.ID;
