<?php
//Classe de MODEL encarregada de la gestió de la taula PELICULA de la base de dades
include_once ("taccesbd.php");
class Tpeli
{
    private $nom;
    private $durada;
    private $recaptaciototal;
    private $abd;
    function __construct($v_nom, $v_durada, $v_recaptaciototal, $servidor,
    $usuari, $paraula_pas, $nom_bd)
    {
        $this->nom = $v_nom;
        $this->durada = $v_durada;
        $this->recaptaciototal = $v_recaptaciototal;
        $var_abd = new TAccesbd($servidor,$usuari,$paraula_pas,$nom_bd);
        $this->abd = $var_abd;
        $this->abd->connectar_BD();
    }

    function __destruct()
    {
        if (isset($this->abd))
        {
        unset($this->abd);
        }
    }

    public function existeixpeli ()
    {
        $res = false;
        if ($this->abd->consulta_SQL("select count(*) as quants from PELICULA
        where nom = '" . $this->abd->escapar_dada($this->nom)."'") )
        {
            if ($this->abd->consulta_fila())
            {
                $res = ($this->abd->consulta_dada('quants') > 0);
            }
        }
        return $res;
    }
    public function novapeli()
    {
        $res = false;
        //es comprova que la pel·lícula no està ja a la base de dades
        if (!($this->existeixpeli()))
        { //si efectivament no hi és, s'insereix
            if ($this->abd->consulta_SQL("insert into PELICULA
            values ('" .
            $this->abd->escapar_dada($this->nom) . "','" .
            $this->abd->escapar_dada($this->durada) . "'," .
            $this->abd->escapar_dada($this->recaptaciototal). ")"))
            {
                 $res = true;
            }
        }
        return $res;
    }

    public function llistatpelis()
    {
        $res = false;
        if ($this->abd->consulta_SQL("select * from PELICULA"))
        {   
            $fila = $this->abd->consulta_fila();
            $res = "<select  name='peli'> ";
            while ($fila != null)
            {
                $nom = $this->abd->consulta_dada('nom');
                $durada = $this->abd->consulta_dada('durada');
                $recap = $this->abd->consulta_dada('recaptacioTotal');
                $res = $res . "<option value='" . $nom . "'>";
                $res = $res . $nom . " - " . $durada . " minuts - " . $recap . "€";
                $fila = $this->abd->consulta_fila();
            }
            $res = $res . "</select>";
            $this->abd->tancar_consulta();
        }
        return $res;
    }


}