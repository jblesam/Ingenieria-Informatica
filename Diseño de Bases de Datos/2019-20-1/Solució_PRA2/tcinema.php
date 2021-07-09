<?php
//Classe de MODEL encarregada de la gestió de la taula CINEMA de la base de dades
include_once ("taccesbd.php");
class Tcinema
{
    private $nom;
    private $ciutat;
    private $abd;
    function __construct($v_nom, $v_ciutat, $servidor, $usuari, $paraula_pas, $nom_bd)
    {
        $this->nom = $v_nom;
        $this->ciutat = $v_ciutat;
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

    public function llistatcinemes()
    {
        $res = false;
        if ($this->abd->consulta_SQL("select * from CINEMA"))
        {   
            $fila = $this->abd->consulta_fila();
            $res = "<select  name='cinema'> ";
            while ($fila != null)
            {
                $nom = $this->abd->consulta_dada('nom');
                $ciutat = $this->abd->consulta_dada('ciutat');
                $res = $res . "<option value='" . $nom . "'>";
                $res = $res . $nom . " - " . $ciutat;
                $fila = $this->abd->consulta_fila();
            }
            $res = $res . "</select>";
            $this->abd->tancar_consulta();
        }
        return $res;
    }

    public function llistatciutats()
    {
        $res = false;
        if ($this->abd->consulta_SQL("select distinct ciutat from CINEMA"))
        {   
            $fila = $this->abd->consulta_fila();
            $res = "<select  name='ciutat'> ";
            while ($fila != null)
            {
                $ciutat = $this->abd->consulta_dada('ciutat');
                $res = $res . "<option value='" . $ciutat . "'>";
                $res = $res . $ciutat;
                $fila = $this->abd->consulta_fila();
            }
            $res = $res . "</select>";
            $this->abd->tancar_consulta();
        }
        return $res;
    }

    public function cartellera()
    {
        $res = false;
        $SQL = "select pr.nompeli, pr.nomcinema, p.durada, p.recaptacioTotal, pr.recaptacio
        from (PROJECCIO pr inner join PELICULA p on pr.nomPeli = p.nom)inner join CINEMA c on pr.nomCinema = c.nom
        where c.ciutat = '" . $this->ciutat ."' order by pr.nompeli";
        if ($this->abd->consulta_SQL($SQL))
        {   
            $fila = $this->abd->consulta_fila();
            $res = "<table border=1><tr bgcolor='lightblue'><th>Pel·lícula</th><th>Cinema</th><th>Durada</th><th>Recaptació</th><th>Rec.Total</th></tr> ";
            while ($fila != null)
            {
                $peli = $this->abd->consulta_dada('nompeli');
                $cine = $this->abd->consulta_dada('nomcinema');
                $durada = $this->abd->consulta_dada('durada');
                $rectotal = $this->abd->consulta_dada('recaptacioTotal');
                $rec = $this->abd->consulta_dada('recaptacio');

                $res = $res . "<tr>";
                $res = $res . "<td>$peli</td>";
                $res = $res . "<td>$cine</td>";
                $res = $res . "<td align='right'>$durada</td>";
                $res = $res . "<td align='right'>$rec</td>";
                $res = $res . "<td align='right'>$rectotal</td></tr>";                
                $fila = $this->abd->consulta_fila();
            }
            $res = $res . "</table>";
            $this->abd->tancar_consulta();
        }
        return $res;
    }
 


}