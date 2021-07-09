<?php
header("Content-Type: text/html;charset=utf-8");

//Classe de CONTROLADOR
include_once ("tpeli.php");
include_once ("tcinema.php");
include_once ("tprojeccio.php");

class TControl
{
	private $servidor;
	private $usuari;
	private $paraula_pas;
	private $nom_bd;
	function __construct()
	{
		/*CONNEXIÓ LOCAL AMB LA BASE DE DADES ANOMENADA cinemes*/
		$this->servidor = "localhost";
		$this->usuari = "root";
		$this->paraula_pas = "";
		$this->nom_bd = "cinemes";
	}

	public function novapeli ($nom, $durada)
	{
		$p = new Tpeli($nom, $durada, 0, $this->servidor,
		$this->usuari, $this->paraula_pas,
		$this->nom_bd);
		$res = $p->novapeli();
		return $res;
	}

	public function projectar ($nompeli, $nomcinema, $recaptacio)
	{
		$pr = new Tprojeccio($nompeli, $nomcinema, $recaptacio, $this->servidor, $this->usuari, $this->paraula_pas, $this->nom_bd);
		$res = $pr->projectar();
		return $res;
	}

	public function cartelleraciutat ($ciutat)
	{
		$ll = new Tcinema ("", $ciutat, $this->servidor, $this->usuari, $this->paraula_pas, $this->nom_bd);
		$res = $ll->cartellera();
		return $res;
	}

	public function llistatpelis()
	{
		$p = new Tpeli("","",0,$this->servidor, $this->usuari, $this->paraula_pas, $this->nom_bd);	
		$res = $p->llistatpelis();
		return $res;
	}

	public function llistatcinemes()
	{
		$p = new Tcinema("","",$this->servidor, $this->usuari, $this->paraula_pas, $this->nom_bd);	
		$res = $p->llistatcinemes();
		return $res;
	}

	public function llistatciutats()
	{
		$p = new Tcinema("","",$this->servidor, $this->usuari, $this->paraula_pas, $this->nom_bd);	
		$res = $p->llistatciutats();
		return $res;
	}
}