<?php
header('Content-Type: text/html; charset="UTF-8"');

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// càrrega de les llibreries de Google Maps API
include_once("GoogleMap.php");
include_once("JSMin.php");

// Funció per a la connexió amb la base de dades 
function connect_ddbb($host, $user, $pwd, $database)
{
	$con =  mysqli_connect($host, $user, $pwd, $database);
	// indiquem que la codificació de caràcters sigui utf8 per tal d'assegurar que els 
	// accents, etc. recuperats de la base de dades es veuran correctament
	mysqli_set_charset($con, "utf8");
	if (!$con)
	{
		die('Impossible realitzar la connexió: ' . mysql_error());
	} 
	return $con;
}

// Connexió a la SGBD i selecció de la base de dades
$host = "localhost";
$user = "";
$pwd = "";
$database = "";
$connection = connect_ddbb($host, $user, $pwd, $database);
$row = null;

// Recuperació del disc indicat per l'usuari a l'URL
if (isset($_GET['disc']))
{
	// es guarda el nom del disc
	$nom_disc = $_GET['disc'];

	// es comprova que existeixi el disc
	$query = "	SELECT d.ID, d.nom disc, l.nom local, l.latitud, l.longitud, l.adreça 
				FROM disc d 
				LEFT JOIN local l ON l.id = d.local_ID
				WHERE UPPER( d.nom ) = UPPER( '$nom_disc' )
				";
	$result = mysqli_query($connection, $query);
	$row = mysqli_fetch_assoc($result);
}

// en cas que no es trobi o no s'hagi passat cap paràmetre, seleccionem un disc a l'atzar
if (!isset($_GET['disc']) || $row == null) 
{
	// es selecciona un disc aleatori d'entre tots els que hi ha a la base de dades 
	$query = "	SELECT d.ID , d.nom disc, l.nom local, l.latitud, l.longitud, l.adreça
				FROM disc d
				LEFT JOIN local l ON l.id = d.local_ID
				ORDER BY RAND( ) LIMIT 1
				";
	$result = mysqli_query($connection, $query);
	$row = mysqli_fetch_assoc($result);

	// es genera el missatge per a l'usuari
$missatge = <<<END
Estimat usuari: el DISC sol·licitat no es troba dins de la nostra base de dades.<br />
Alternativament, s'ha seleccionat un a l'atzar representant el local de la seva presentació en el següent mapa.<br /><br />
EL DISC RECUPERAT ÉS <b>%s</b><br><br>
END;
}

// es recuperen les dades
$id_disc = $row['ID'];
$nom_disc = $row['disc'];
$nom_local = $row['local'];
$lat_local = $row['latitud'];
$lon_local = $row['longitud'];
$adreca_local = $row['adreça'];

// es recuperen les cançons del disc que han estat enregistrades en estudi
$cançons = "SELECT c.id, c.nom, c.duració 
			FROM cançó c
			LEFT JOIN enregistrar e ON e.cançó_ID = c.ID
			LEFT JOIN disc d ON d.ID = e.disc_ID
			WHERE d.ID = $id_disc
			AND e.en_concert = 'No'
			";


// Generació del mapa
$MAP_OBJECT = new GoogleMapAPI(); 
$MAP_OBJECT->_minify_js = isset($_REQUEST["min"])? FALSE : TRUE; 
$MAP_OBJECT->setMapType("map"); 
$MAP_OBJECT->setZoomLevel("12");	

// Definició del tamany del Mapa
$MAP_OBJECT->setHeight('400'); 
$MAP_OBJECT->setWidth('600'); 

// es crea un marcador en verd per posicionar el local
$green_icon = 'http://maps.google.com/mapfiles/ms/icons/green-dot.png';
$title_sidebar = '<p>local: '.$nom_local.' <br />Adre&ccedil;a: '.$adreca_local.' </p>';
$MAP_OBJECT->addMarkerByCoords($lon_local, $lat_local, '', "Local: ".$nom_local, $tooltip='', $green_icon);

// Es realitza la cerca de cançons que han tocat al local
$result = mysqli_query($connection, $cançons);

$llistat = "<table>";
$llistat .= "<tr><th style='text-align:left; width: 200px;'>Cancó</th><th style='text-align:left; width: 100px;'>Duració</th></tr>";
while($row = mysqli_fetch_assoc($result)) 
{
	$llistat .= "<tr><td style='text-align:left;'>".$row['nom']."</td><td style='text-align:left;'>".$row['duració']."</td></tr>";
}
$llistat .= "</table>";
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Posiciona</title>
<!-- gmaps Javascript Code -->
<?=$MAP_OBJECT->getHeaderJS();?>
<?=$MAP_OBJECT->getMapJS();?>
</head>
<body style='font-family: Arial; font-size: 10pt'>
<?=isset($missatge)?sprintf($missatge, $nom_disc):""?>
<h3>Situem la posici&oacute; del local al mapa</h3>
<?=$MAP_OBJECT->printOnLoad();?>
<?=$MAP_OBJECT->printMap();?>
<?=$MAP_OBJECT->printSidebar();?>
<br><br>
<?=$llistat ?>
</body>
</html>

