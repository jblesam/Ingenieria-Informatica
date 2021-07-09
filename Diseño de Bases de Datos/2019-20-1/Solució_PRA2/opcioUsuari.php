<?php
header("Content-Type: text/html;charset=utf-8");

if (isset($_POST["opcio"]))
{
	$opcio = $_POST["opcio"];
	switch ($opcio)
	{
		case "novapeli":
			include_once("novapeli.html");
			break;
		
		case "projectar":
		
			include_once("projectar.html");
			break;
			
		case "cartellera":
			include_once("cartellera.html");
			break;
	
		default:
			echo "<br>ERROR: Opció no disponible<br>";
	}
}
?>