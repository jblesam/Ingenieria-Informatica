<?php
//Classe de MODEL especialitzada en l'accés a la base de dades.
//Centralitza totes les peticions de sentències SQL de les altres
//classes de MODEL
class TAccesbd
{
    //Aquestes quatre propietats privades guarden les dades de connexió a la base de dades
    private $bd;
    private $host;
    private $user;
    private $pass;
    //La pròpia classe de gestió de la base de dades guarda els
    //objectes necessaris per realitzar aquesta gestió.
    //Així, des del programa extern que la faci servir, no cal
    //preocupar-se ni de com es fa aquesta connexió ni com es guarda

    private $connexio; //Connexió real amb la base de dades.
    private $dades; //Dades reals retornades per una consulta amb
    //èxit (i dades, clar...)
    private $fila; //Una de les files de les dades de la consulta
    //realitzada
    //Constructor de la classe. Serveix per poder crear objectes de la
    //classe. Li hem d'indicar les dades de connexió
    
    function __construct($host , $user , $pass, $bd)
    {
        $this->bd = $bd;
        $this->host = $host;
        $this->user = $user;
        $this->pass = $pass;
    }
    
    //Realitza la connexió a la base de dades, amb les dades de
    //connexió indicades al constructor de la classe
    public function connectar_BD()
    {
        $res = true;
        $this->connexio = mysqli_connect ($this->host, $this->user,
        $this->pass, $this->bd);
        mysqli_set_charset($this->connexio,"utf8");
        if (!$this->connexio)
        {
            $res = false;
            die("No s'ha pogut realitzar la connexió. ERROR:" .
            mysqli_connect_error());
        }
        return $res;
    }
    
    //Desconnecta de la base de dades.
    public function desconnectarBd()
    {
        if (isset($this->connexio))
        {
            mysqli_close($this->connexio);
        }
    }
    
    // Per tal d'evitar atacs de SQL-Injection, aquesta funció
    // retorna la dada que se li passi filtrada de caràcters
    // "perillosos"
    public function escapar_dada ($dada)
    {
        return mysqli_real_escape_string($this->connexio,$dada);
    }

    /*Executa un SQL, ja sigui Select (el retorn del qual és un
    dataset) o insert, update o delete (que retorna cert o fals
    depenent de com hi hagi anat)
    Es dona per fet que la connexió s'ha realitzat prèviament
    Si el SQL és un SELECT ,retorna el conjunt global de resultats del
    SELECT.
    Posteriorment s'haurà de fer servir la funció "Consulta_fila" per
    obtenir la primera fila (o posteriors) de resultats
    */
    public function consulta_SQL ($consulta)
    {
        $this->dades = mysqli_query ($this->connexio, $consulta);
        if (mysqli_errno($this->connexio) != 0)
        {
            $res = false;
        }
        else
        {
            $res = true;
        }
        return $res;
    }

    //Funció que obté la fila de dades d'una consulta prèviament
    //realitzada. Retorna totes les dades de la fila per ser
    //consultades posteriorment amb "consulta_dada"
    public function consulta_fila ()
    {
        $this->fila = null;
        if ($this->dades != null)
        {
            $this->fila = mysqli_fetch_assoc($this->dades);
        }
        return $this->fila;
    }
    
    /*
    Funció que després de fer un "consulta_fila", i donat el nom d'un
    camp de la consulta, retorna la dada del camp del registre actual.
    Tant si el nom del camp no existeix als resultats, com si ja s'han
    consultat totes les files del resultat, la funció retorna NULL
    */
    public function consulta_dada ($camp)
    {
        $res = null;
        if ($this->fila != null)
        {
            $res = $this->fila[$camp];
        }
        return $res;
    }

    //Retorna el número de files involucrades a la darrera
    //consulta_SQL
    public function files_afectades ()
    {
        $res = 0;
        if ($this->connexio != null)
        {
            $res = mysqli_affected_rows($this->connexio);
        }
        return ($res);
    }

    //Elimina la memòria associada a la darrera consulta realitzada
    public function tancar_consulta ()
    {
        mysqli_free_result($this->dades);
    }

    //Retorna el darrer missatge d'error produït a una consulta SQL
    public function missatge_error ()
    {
        $res = "";
        if (mysqli_errno($this->connexio) != 0)
        {
            $res = mysqli_error($this->connexio);
        }
        return $res;
    }
}
?>