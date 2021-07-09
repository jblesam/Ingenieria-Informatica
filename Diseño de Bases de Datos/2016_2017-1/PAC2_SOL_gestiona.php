<!DOCTYPE html>
<?php
header('Content-Type: text/html; charset="UTF-8"');

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Funció per a la connexió amb la base de dades 
function connect_ddbb($host, $user, $pwd, $database)
{
	$con =  mysqli_connect($host, $user, $pwd, $database);
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

$llistat_professors = "";
$llistat_assignatures = "";

$missatge_no_valid = "Les dades informades no són vàlides. No es realitza cap acció";
$missatge_no_insert = "";
$missatge_ciutat = "";
$missatge_insert = "";

// es recupera el valor del professor i les assignatures amb les que es treballaran
if (isset($_POST["professor"]) && isset($_POST["assignatura"]))
{
	$professor = $_POST["professor"];
	$assignatures = implode (", ", $_POST["assignatura"]); // l'implode ens permetrà treballar amb els ids de les assignatures com si fossin una cadena de text

	// consultem a la base de dades que els valors passats existeixen
	$query_check_professor="select id, nom, cognoms from Professor where id=$professor";
	$query_check_assignatures="select id, nom from Assignatura where id in ($assignatures)";

	$result_check_professor = mysqli_query($connection, $query_check_professor);
	$result_check_assignatures = mysqli_query($connection, $query_check_assignatures);

	// es comprova que el professor i les assignatures estan a la base de dades
	$assignatures_valides = array();
	$index = 0;
	
	// recorrem el resultat obtingut per trobar les assignatures vàlides
	while($professor_row = mysqli_fetch_assoc($result_check_professor)) {
		while($assignatura_row = mysqli_fetch_assoc($result_check_assignatures)) {
			$assignatures_valides_id[$index] = $assignatura_row["id"];
			$assignatures_valides_nom[$index] = $assignatura_row["nom"];
			$index++;
		}
		
		// comprovem que el professor ja té assignada l'assignatura
		$query_check_impartir="
			select i.assignatura_id assignatura_id, a.nom assignatura_nom
			from Impartir i 
			join Assignatura a on i.assignatura_id = a.id 
			where professor_id = $professor and assignatura_id in (".implode (", ", $assignatures_valides_id).")";
		$result_check_impartir=mysqli_query($connection, $query_check_impartir);

		$assignatures_existents_id = array();
		$assignatures_existents_nom = array();
		$index = 0;
		
		// recorrem el resultat obtingut per trobar les assignatures existents per aquest professor
		while($impartir_row = mysqli_fetch_assoc($result_check_impartir)) {
			$assignatures_existents_id[$index] = $impartir_row["assignatura_id"];
			$assignatures_existents_nom[$index] = $impartir_row["assignatura_nom"];
			$index++;
		}
		
		// si ha en té alguna, generem el missatge
		if (sizeof($assignatures_existents_id)>0) {
			$missatge_no_insert = "El professor ".$professor_row["nom"]." ".$professor_row["cognoms"] ." ja imparteix actualment les assignatures ".implode (", ", $assignatures_existents_nom) ." de manera que no s’ha realitzat cap operació per aquestes assignatures.";
		}

		// obtenim les assignatures que s'insertaran a la base de dades per aquest professor (restem les vàlides de les ja existents)
		$assignatures_insert_id = array_diff($assignatures_valides_id, $assignatures_existents_id);
		$assignatures_insert_nom = array_diff($assignatures_valides_nom, $assignatures_existents_nom);

		// si la diferència no és el conjunt buit
		if (sizeof($assignatures_insert_id)>0) {
			
			// inserim les dades a la taula Impartir
			$insert="insert into Impartir (professor_id, assignatura_id) SELECT $professor, id from Assignatura where id in (".implode (", ", $assignatures_insert_id).")";
			
			// si tot ha anat bé, mostrem el missatge
			if (mysqli_query($connection, $insert)) {
				$missatge_insert = "S’ha realitzat l’operació de gestió <b>INSERCIÓ</b> sobre el professor ".$professor_row["nom"]." ".$professor_row["cognoms"] ." i les assignatures ".implode (", ", $assignatures_insert_nom) .".";
			} else {
    			$missatge_insert = "Error: " . $sql . "<br>" . mysqli_error($conn);
			}

			// es consulta la base de dades les assignatures que s'imparteixen a la ciutat on el professor resideix
			$query_check_city="
				SELECT ass.id, ass.nom 
				FROM Professor p 
				INNER JOIN Ciutat c ON c.id = p.ciutat 
				INNER JOIN Edifici e ON e.ciutat = c.id 
				INNER JOIN Aula a ON a.edifici_id = e.id 
				INNER JOIN Assignatura ass ON ass.aula = a.id 
				WHERE p.id = $professor and ass.id in (".implode (", ", $assignatures_insert_id).")";
			$result_check_city=mysqli_query($connection, $query_check_city);

			$assignatures_ciutats_id = array();
			$assignatures_ciutats_nom = array();
			$index = 0;

			// recorrem les assignatures 
			while($ciutat_row = mysqli_fetch_assoc($result_check_city)) {
				$assignatures_ciutats_id[$index] = $impartir_row["id"];
				$assignatures_ciutats_nom[$index] = $impartir_row["nom"];
				$index++;
			}

			// trobem la diferencia entre les assignatures vàlides i les que s'imparteixen a la ciutat on el professor resideix
			$ciutats_no = array_diff($assignatures_insert_nom, $assignatures_ciutats_nom);
			if (sizeof($ciutats_no) > 0) {

				// en cas que existeixin, mostrem el missatge
				$missatge_ciutat = "<b>ALERTA:</b> El professor ".$professor_row["nom"]." ".$professor_row["cognoms"]." no resideix a la ciutat on impartirà les assignatures ".implode (", ", $ciutats_no);
			}
		}
	}
}

// S'hagin passat dades o no, es recupera la informació per mostrar en el formulari
$query_professors="select * from Professor";
$query_assignatures="select * from Assignatura";

$result_professors = mysqli_query($connection, $query_professors);
$result_assignatures = mysqli_query($connection, $query_assignatures);

// es genera el contingut del combo de professors
while($row = mysqli_fetch_assoc($result_professors)) {
	$llistat_professors .= 
		'<option value="'.$row["id"].'">'.$row["nom"].' '.$row["cognoms"].'</option>';
}

// es genera el contingut del combo d'assignatures
while($row = mysqli_fetch_assoc($result_assignatures)) {
	$llistat_assignatures .= 
		'<option value="'.$row["id"].'">'.$row["nom"].'</option>';
}
?>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head 
         content must come *after* these tags -->
    
    <title>Gestiona - PAC2</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/bootstrap-theme.min.css" rel="stylesheet">
   
   	<!-- custom css -->
    <link href="css/dbd.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>

    <header class="jumbotron">
        <div class="container">
            <div class="row">
            	<div class="col-xs-12 col-sm-1">
                </div>
               	<div class="col-xs-12 col-sm-11">
                    <h1>Gestiona - PAC2</h1>
                 </div>
            </div>
        </div>
    </header>

	<div class="container">
    	<div class="row">
			<div class="col-xs-12 col-sm-6">
			<form action="" method="post">
		        <div class="row row-content">
		        	<div class="col-xs-12 col-sm-3">
		        	</div> 
		            <div class="col-xs-12 col-sm-9">
		                <h2>Professors</h2>
						<select name="professor" class="form-control">
						<?=$llistat_professors?>
						</select>
		            </div>
		        </div>
				<div class="row row-content">
		            <div class="col-xs-12 col-sm-3">
		        	</div> 
		            <div class="col-xs-12 col-sm-9">
		                <h2>Assignatures</h2>
		                <select name="assignatura[]" class="form-control" multiple>
						<?=$llistat_assignatures?>
						</select>
		            </div>
		        </div>
		        <div class="row row-content">
		            <div class="col-xs-12 col-sm-3">
		        	</div> 
		            <div class="col-xs-12 col-sm-9">
		               <input type="submit" class="btn btn-default" value="Enviar" />
					   <input type="button" class="btn btn-default" value="Netejar" />
		            </div>
		        </div>
		    </form>
			</div>
			<div class="col-xs-12 col-sm-5 col-sm-offset-1">
				<div class="row row-message top-buffer">
					<?=$missatge_no_insert?>
				</div>
				<div class="row row-message top-buffer">
					<?=$missatge_insert?>
				</div>
				<div class="row row-message top-buffer">
					<?=$missatge_ciutat?>
				</div>
			</div>
    	</div>
  

    </div>

    <footer class="row-footer">
        <div class="container">
            <div class="row">  
            	<div class="col-xs-12 col-sm-1">
        		</div>
           		<div class="col-xs-12 col-sm-11">
	            	<h5>Links</h5>
	            	<ul class="list-unstyled">
	            			<li><a href="posiciona.php">Posiciona</a></li>
	            			<li>Gestiona</li>
	            	</ul>           
	           	</div>
            </div>
        </div>
    </footer>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
</body>

</html>