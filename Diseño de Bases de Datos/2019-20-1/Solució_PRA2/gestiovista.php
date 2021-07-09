<?php
header("Content-Type: text/html;charset=utf-8");
include_once("tcontrol.php");

function mostrarError ($missatge)
{
	echo "<table bgcolor=grey align=center border = 1 cellpadding = 10>";
	echo "<tr><td><br><h2> $missatge </h2><br><br></td></tr>";
	echo "</table>";		
};

function mostrarMissatge ($missatge)
{
	echo "<table bgcolor=#ffffb7 align=center border = 1 cellpadding = 10>";
	echo "<tr><td><br><h2> $missatge </h2><br><br></td></tr>";
	echo "</table>";		
};


if (isset($_POST["opcio"]))
{
	$opcio = $_POST["opcio"];
	switch ($opcio)
	{
		case "Nova pel·lícula":
		{
			if (isset($_POST["nom"]) && isset($_POST["durada"]))
			{
				$nom = $_POST["nom"];
				$durada = $_POST["durada"];
				$c = new TControl();
				if ($c->novapeli($nom, $durada))
				{
					mostrarMissatge("Pel·lícula donada d'alta amb èxit");
					echo ("<a href='index.html'> Tornar </a>");
				}
				else
				{
					mostrarError("Error en donar d'alta la pel·lícula");
					echo ("<a href='index.html'> Tornar </a>");
				}
			}
			break;
		}

		case "Projectar":
		{	
			if (isset($_POST["peli"]) && isset($_POST["cinema"]) && isset($_POST["recaptacio"]))
			{
				$peli = $_POST["peli"];
				$cinema = $_POST["cinema"];
				$recaptacio = $_POST["recaptacio"];
				$c = new TControl();
				if ($c->projectar($peli, $cinema, $recaptacio))
				{
					mostrarMissatge("Projecció realitzada amb èxit");
					echo ("<a href='index.html'> Tornar </a>");
				}
				else
				{
					mostrarError("Error en realitzar la projecció");
					echo ("<a href='index.html'> Tornar </a>");
				}
			}
			break;
		}

		case "Cartellera":
		{
			if (isset($_POST["ciutat"]))
			{
				$ciutat = $_POST["ciutat"];
				$c = new TControl();
				$res = $c->cartelleraciutat($ciutat);
				if ($res)
				{
					echo ('<html>

					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
						<title> PRA2 Cartellera </title>
					</head>
					
					<body>
						<center>
							<h1>CARTELLERA DE LA CIUTAT DE <br>'.$ciutat.' <br></h1>
							<br> <br>');
					echo ($res);
					echo ('<br><a href="index.html"> Tornar </a></center></body></html>');
				}
				else
				{
					mostrarError("Error en generar la cartellera de la ciutat");
				}
			}
			break;	
		}
		default:
			mostrarError("Error: opció incorrecta");
			echo ("<a href='index.html'> Tornar </a>");
	}
}
else
{
	mostrarError("ERROR: Cal indicar totes les dades");
	echo ("<a href='index.html'> Tornar </a>");
}




