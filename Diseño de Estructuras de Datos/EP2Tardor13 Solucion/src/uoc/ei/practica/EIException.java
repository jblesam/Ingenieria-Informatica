package uoc.ei.practica;

/**
 * Excepció específica del gestor.
 *
 * @author   Equip docent d'Estructura de la Informació de la UOC
 * @version  Tardor 2006
 */
public class EIException  extends Exception
{

	private static final long serialVersionUID = -2577150645305791318L;

/**
    * Constructor amb un paràmetre.
    * @param msg  missatge que ha de mostrar l'excepció
    */
   public EIException(String msg) { super(msg); }
}
