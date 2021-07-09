<!DOCTYPE html>
<?php
// Classe per emmagatzemar les dades obtingudes de la base de dades
class ruta {
  public $conductor = null;
  public $destins = null;
  public $nom_ruta = null;
  public $km = 0;
  public $inici = null;
  public $fin = null;
  public $consum = null;
  public $peatge = null;
  public $incidencia = null;
}

// Iniciem un objecte buit
$info_ruta = new ruta();

// Declaració de variables
$resultat = null;  // Variable auxiliar per recuperar els registres
$aleatori = "";    // Emmagatzemarà el text a pintar si el conductor és aleatori
$destins = null;   // Llista dels diferents destins
$bloc_li = null;   // Bloc per compondre els tags <li> del carrussell
$bloc_img = null;  // Bloc per compondre els tags de l'ordre de les imatges

// Variables de conexió
$mysql_server = "localhost";
$mysql_user   = "root";
$mysql_pass   = "";
$mysql_db     = "rutes";

// Si estem al servidor de la UOC canviem les credencials
if ($_SERVER['HTTP_HOST'] == 'eimtdbd.uoc.edu') {
	$mysql_server = "localhost";
	$mysql_user   = "ppuertase";
	$mysql_pass   = "********";
	$mysql_db     = "ppuertase";
} 

// Generem el header de la pàgina
header ( 'Content-Type: text/html; charset="UTF-8"' );


// CODI PHP

// En aquest bloc haureu d'introduïr les instruccions PHP necessàries per
// · connectar-vos a la base de dades
// · recuperar el DNI del conductor passat per GET (o seleccionar un de forma aleatòria si no es passa)
// · recuperar la darrera ruta seguida pel conductor

// Conectem a la base de dades indicant les credencials
if (! ($iden = mysqli_connect ( $mysql_server, $mysql_user, $mysql_pass )))
 die ( "Error: No se pudo conectar" );
 
 // Selecciona la base de dades
if (! mysqli_select_db ( $iden, $mysql_db ))
 die ( "Error: No existe la base de datos" );

// Important indicar que les dades estan en UTF-8
mysqli_set_charset ( $iden, "utf8" );

// Comprovem si tenim el paràmetre DNI per consultar les dades
if (isset ( $_GET ['DNI'] )) {
 // Seleccionar el conductor, si no te rutes el camp t.data_finalització estarà a null	
 $sentencia = "select c.*, t.data_finalització from conductor c left join transport t on (c.camió_matrícula = t.matrícula) where dni = UPPER('". $_GET ['DNI'] . "') ";
              "order by t.data_finalització desc limit 1 ";
 $resultat = mysqli_query ( $iden, $sentencia );
 if ($resultat && $resultat->num_rows > 0) {
 	$info_ruta->conductor = mysqli_fetch_assoc ( $resultat );
 	// Si no te data de finalització significa que no te cap ruta
 	if ($info_ruta->conductor['data_finalització'] == null) {
 		$aleatori = "Estimat usuari, el conductor sol•licitat ".$info_ruta->conductor ['nom'] ." " . $info_ruta->conductor['cognoms'] . " (".$info_ruta->conductor ['DNI'] .")" ." no te cap ruta. Hem triat un altre conductor a l'atzar: <br><br> ";
 		$resultat = null; // Posem la variable a nul perquè busqui un aleatori
 	}
 }
}

// Si no hem obtingut un conductor o no han passat el paràmetre DNI la variable $resultat serà NULL o el nombre de registres serà zero
if (!$resultat || $resultat->num_rows == 0) {
 // Si no hem trobat el conductor la variable $aleatori estarà buida	
 if ($aleatori == "") $aleatori = "Estimat usuari, el conductor sol•licitat no es troba dins de la nostra base de dades. Alternativament, s’ha seleccionat un a l’atzar: <br><br>";
 $sentencia = "select c.* from conductor c, transport t where c.camió_matrícula = t.matrícula ".
               "order by rand() limit 1 "; 
 // Ejecutem la consulta per trobar un conductor aleatoriament
 $resultat = mysqli_query ( $iden, $sentencia );
 $info_ruta->conductor = mysqli_fetch_assoc ( $resultat );
}

// Consulta per trobar el detall de la ruta del conductor, ciutats, dates, cost, etc.
$sentencia =  "SELECT ci.*, r.codi_ruta, ru.nom as nom_ruta, ". 
              "DATE_FORMAT(r.data_inici,'%d/%m/%Y') as data_inici, DATE_FORMAT(r.data_finalització,'%d/%m/%Y') as data_finalització, ".
              "it.distància, ru.cost_peatge, r.incidències, c.consum " .
              " FROM ciutat ci, itinerari it, ruta ru, camió c, " .
              " (SELECT t.* FROM conductor c, transport t " . 
              "  WHERE t.matrícula = c.camió_matrícula AND c.DNI = '". $info_ruta->conductor['DNI'] . "'" . 
              " ORDER BY t.data_finalització DESC LIMIT 1) r " . 
              "WHERE it.codi_ruta = r.codi_ruta AND ci.id = it.ciutat_partida " .
              "  and ru.codi_ruta = r.codi_ruta ".
              "  and c.matrícula  = r.matrícula ";
 
 
$resultat = mysqli_query ( $iden, $sentencia );
 
if ($resultat) {
 $bloc_li = "";
 $bloc_img = "";
 $n = 0; 
 while($destins = mysqli_fetch_assoc ( $resultat )) {
  // Per el primer registre agafem les dades fixes
  if ($n == 0) {
    $info_ruta->data_inici = $destins['data_inici'];
    $info_ruta->nom_ruta = $destins['nom_ruta'];
    $info_ruta->inici = $destins['data_inici'];
    $info_ruta->fin = $destins['data_finalització'];
    $info_ruta->consum = $destins['consum'];
    $info_ruta->peatge = $destins['cost_peatge'];
    $info_ruta->incidencia = $destins['incidències'];
  } else {
  	// Afegim a la variable de la ruta un guió excepte per el primer registre
    $info_ruta->destins = $info_ruta->destins . ' - ';
  }
  // Afegim les ciutats a la variable de la ruta i els km
  $info_ruta->destins = $info_ruta->destins . $destins['acrònim'];
  $info_ruta->km = $info_ruta->km + $destins['distància'];
  
  // Generem les linies <li>
  $bloc_li = $bloc_li . "<li data-target='#myCarousel' data-slide-to='{$n}'";
  // Si és la primera la posem com activa
  if ($n == 0) $bloc_li = $bloc_li . " class='active'";
  // Tanquem el tag </li>
  $bloc_li = $bloc_li . "></li>\n";
   
  // Generem el bloc de les imatges, el nom del fitxer és l'acrònim de la ciutat 
  $bloc_img = $bloc_img . "<div class='item ". (($n == 0) ? "active'>\n" : "'>\n") .
                           "<p>". $destins['nom'] . "</p>" . 
                           "<img src='http://eimtdbd.uoc.edu/~groomete/imatges/".$destins['acrònim'].".png' alt='".
                           $destins['nom']."' width='709' height='276'>\n</div>";
  $n = $n+1;
 }
} 

?>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>[DBD] RUTES - PRA1 </title>
<link rel="stylesheet"  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css">

<!-- custom css -->
<link href="http://eimtdbd.uoc.edu/~groomete/css/dbd.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

<style>
body {overflow : hidden;}
.jumbotron {padding: 10px 30px 20px 30px;  margin: 0px auto; background: #7986CB;  color: floralwhite; font-size: 1.3vw;}
.jumbotron h1 {font-size: 2.5vw; }
.jumbotron img {position: absolute; right: 12px; width: 22vw; max-width: 200px;}
#main {overflow: hidden; padding-bottom: 150px;}   
.top-buffer {margin-top: 5px;}
.carousel-inner p {    position: absolute; top: 0px; font-size:1.5vw; font-weight: bold; color: #fff; width: 15%; background: black; text-align: center;}
.conductor {font-size: 20px; margin : 0;}
.info {font-size: 14px; margin : 0; color: #79667B;}
.info b {color: #444;}
.incidencia {font-size: 14px; margin : 0; color: red}

.row-footer {background-color: #AFAFAF;margin: 0px auto;padding: 10px 0px 10px 0;position: fixed;height: 76px;clear: both;bottom: 0px;width: 100%;}
.h1, h1 {font-size: 6vw;}
#wrap {min-height: 60%; overflow-y : auto;}
</style>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

</head>
<body>
  <header class="jumbotron">
    <div class="container">
      <div class="row">
        <div class="col-xs-12"></div>
        <div class="col-xs-12 col-sm-11">
          <h1>[DBD] RUTES - PRA1</h1>
          Pedro Puertas Estivill
        </div>
        <img alt="" src="uoc_masterbrand_3linies_blanc.png">
      </div>
    </div>
  </header>


  <div id="wrap">
    <div id="main" class="container clear-top">

      <div class="container">
        <div class="row">
          <div class="col-xs-12 col-sm-12">
            <div class="row row-message top-buffer">
              <!-- 
              Aquí s'indicarà la informació relacionada amb el conductor i la ruta mostrada
              Haureu de substituïr aquest codi per un generat dinàmicament a partir de la informació recuperada de la base de dades
              -->
              <?php
                // Pintem el missatge si hem cercat les dades aleatòriament
                echo $aleatori;
               
               // Si tenim dades les pintem a la pantalla 
               if ($info_ruta != null) {
               	 // Pintem les dades bàsiques del conductor
               	 echo '<p class="conductor"><b>'. $info_ruta->conductor ['nom'] . ' ' . $info_ruta->conductor ['cognoms'] . '</b> amb DNI : ' . $info_ruta->conductor['DNI'] . "</p>";
               	 // Sota de la informació bàsica indiquem les dades de la ruta
               	 echo '<p class="info">';
                 echo '<b>Última ruta : </b>'. $info_ruta->nom_ruta. ' (' . $info_ruta->destins .') '.$info_ruta->km . " km &nbsp;&nbsp;&nbsp;&nbsp;";
                 echo '<b>Data : </b>'. $info_ruta->inici . ' - ' . $info_ruta->fin . "&nbsp;&nbsp;&nbsp;";
                 echo '<b>Cost : </b> '. number_format($info_ruta->km * $info_ruta->consum / 100 * 0.84, 2, '.', '') .'€ (benzina)  ';
                 if ($info_ruta->peatge > 0) echo $info_ruta->peatge . '€ (peatge)'; 
                 echo '</p>';
                 if ($info_ruta->incidencia != null && $info_ruta->incidencia != 'Cap incidència') {
                   echo '<p><b>Incidències</b> : <span class = "incidencia">' . $info_ruta->incidencia . '</span></p> ';
                 }
               } 
              ?>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-xs-12 col-sm-12">
              <!-- 
              Aquí s'asigna l'ordre en què es veuran les imatges al carrusel
              Haureu de substituïr aquest codi per un generat dinàmicament a partir de la informació recuperada de la base de dades
            -->
            <?php 
              // El carrusell només el pinta si tenim dades, si no indica que no hi ha dades
              if ($bloc_li != null && $bloc_li != "") {
            ?>
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
            <?php   	
                  echo "<ol class='carousel-indicators'>";
                  echo $bloc_li;
                  echo "</ol>";
    	      ?>
              <div class="carousel-inner" role="listbox">
              <?php echo $bloc_img; ?>
              </div>
              <!-- Controls -->
              <a class="left carousel-control" href="#myCarousel"
                role="button" data-slide="prev"> <span
                class="glyphicon glyphicon-chevron-left"
                aria-hidden="true"></span> <span class="sr-only">Previous</span>
              </a> <a class="right carousel-control" href="#myCarousel"
                role="button" data-slide="next"> <span
                class="glyphicon glyphicon-chevron-right"
                aria-hidden="true"></span> <span class="sr-only">Next</span>
              </a>
            </div>
            <?php 
              } else {
              	echo "No hi ha rutes";
              }
            ?>
          </div>
        </div>
      </div>
    </div>
  </div>

  <footer class="row-footer">
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-1"></div>
        <div class="col-xs-12 col-sm-11">
          <h5>Links Activitats:</h5>
          <ul class="list-unstyled">
            <!-- <li><a href="rutes.php">Rutes</a></li> -->
            <li>Rutes</li>
          </ul>
        </div>
      </div>
    </div>
  </footer>

</body>
</html>
<?php 
// Libera la memoria del resultat
mysqli_free_result ( $resultat );

// Tanca la conexión a la base de datos
mysqli_close ( $iden );

?>
