<?php
//Classe de MODEL encarregada de la gestió de la taula PROJECCIO de la base de dades
include_once ("taccesbd.php");
class Tprojeccio
{
    private $nompeli;
    private $nomcinema;
    private $recaptacio;
    private $abd;
    function __construct($v_nompeli, $v_nomcinema, $v_recaptacio, $servidor,
    $usuari, $paraula_pas, $nom_bd)
    {
        $this->nompeli = $v_nompeli;
        $this->nomcinema = $v_nomcinema;
        $this->recaptacio = $v_recaptacio;
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

    public function existeixprojeccio ()
    {
        $res = false;
        if ($this->abd->consulta_SQL("select count(*) as quants from PROJECCIO
        where nompeli = '" . $this->abd->escapar_dada($this->nompeli)."' and 
        nomcinema ='" .  $this->abd->escapar_dada($this->nomcinema) . "'") )
        {
            if ($this->abd->consulta_fila())
            {
                $res = ($this->abd->consulta_dada('quants') > 0);
            }
        }
        return $res;
    }
    public function projectar()
    {
        $res = false;
        if ($this->recaptacio >= 0)
        {
            //es comprova si la pel·lícula no s'està projectant ja al cinema ja a la base de dades
            //Si és així, s'introdueix la nova projecció a la base de dades.
            //Si ja s'està projectant, s'actualitza la recaptació
            if (!($this->existeixprojeccio()))
            { //si efectivament no hi és, s'insereix
                if ($this->abd->consulta_SQL("insert into PROJECCIO
                values ('" .
                $this->abd->escapar_dada($this->nompeli) . "','" .
                $this->abd->escapar_dada($this->nomcinema) . "'," .
                $this->abd->escapar_dada($this->recaptacio). ")"))
                {
                    $res = true;
                }
            }
            else
            {
                //ja s'està projectant -> actualitzem la recaptació
                if ($this->abd->consulta_SQL("update PROJECCIO set recaptacio = recaptacio + " .
                $this->abd->escapar_dada($this->recaptacio) . " where nompeli = '" .
                $this->abd->escapar_dada($this->nompeli) . "' and nomcinema = '" .
                $this->abd->escapar_dada($this->nomcinema) . "'" ))
                {
                    $res = true;
                }
            }
            if ($res = true)
            {
                //s'actualitza el camp recaptacioTotal de la pel·lícula
                $SQL = "update PELICULA set recaptacioTotal = recaptacioTotal + " . 
                $this->abd->escapar_dada($this->recaptacio) . " where nom = '" .
                $this->abd->escapar_dada($this->nompeli) . "'";
                if ($this->abd->consulta_SQL($SQL))
                {
                    $res = true;
                }         
                else
                {
                    $res = false;
                }
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