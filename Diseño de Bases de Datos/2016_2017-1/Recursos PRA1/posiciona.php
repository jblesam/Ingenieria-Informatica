<?php

# Una coordenada d'exemple
$long=2.194465;
$lat=41.406553;
# Carreguem les dos clases
include_once("GoogleMap.php");      
include_once("JSMin.php"); 

# Creacio del Google Maps
$MAP_OBJECT = new GoogleMapAPI(); 
$MAP_OBJECT->_minify_js = isset($_REQUEST["min"])? FALSE : TRUE; 
# Tipus de mapa
$MAP_OBJECT->setMapType("map"); 
# Nivel del Zoom 
$MAP_OBJECT->setZoomLevel("12");	
# Es crea un marquer per posició
$MAP_OBJECT->addMarkerByCoords($long, $lat, 'Marca per coordenades', 'Descripció 1');	
# Definicio del tamany del Mapa
$MAP_OBJECT->setHeight('400'); 
$MAP_OBJECT->setWidth('500');      

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Exemple de GoogleMapsAPI</title>
<!-- gmaps Javascript Code -->
<?=$MAP_OBJECT->getHeaderJS();?>
<?=$MAP_OBJECT->getMapJS();?>
</head>
<body>
<h3>Situem la posició al mapa</h3>
<?=$MAP_OBJECT->printOnLoad();?>
<?=$MAP_OBJECT->printMap();?>
<?=$MAP_OBJECT->printSidebar();?>
</body>
</html> 
