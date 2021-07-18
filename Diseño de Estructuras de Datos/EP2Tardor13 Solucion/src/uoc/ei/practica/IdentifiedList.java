package uoc.ei.practica;

import uoc.ei.tads.Iterador;
import uoc.ei.tads.LlistaEncadenada;

public class IdentifiedList<E> extends LlistaEncadenada<E> {

		
	/** Cerca un objecte dins d'una llista encadenada d'objectes que siguin IdentifiedObject.
	 * 
	 * @param objects Llista d'objectes on cercar.
	 * @param identifier Identificador de l'objecte a cercar.
	 * @param exceptionMessage Missatge amb el que es crea l'excepció si no es troba l'objecte.
	 * @return El primer objecte que té l'identificador igual que el paràmetre identifier; o null si no se'n troba cap.
	 * @throws EIException En cas de no haver trobat l'objecte i només si s'ha especificat un
	 * missatge.
	 */
	protected  E getIdentifiedObject(String identifier, String exceptionMessage) throws EIException {
		IdentifiedObject result=null;
		if (this.nombreElems()>0) {
			Iterador<? extends IdentifiedObject> iterator=(Iterador<? extends IdentifiedObject>) super.elements();
			while (iterator.hiHaSeguent() && result==null) {
				IdentifiedObject current=iterator.seguent();
				if (current.getIdentifier().equals(identifier))
					result=current;
			}
		}
		if (result==null && exceptionMessage!=null)
		throw new EIException(exceptionMessage);

		return (E)result;
	}
	
	
	/** Cerca un objecte dins d'una llista encadenada d'objectes que siguin IdentifiedObject.
	 * 
	 * @param objects Llista d'objectes on cercar.
	 * @param identifier Identificador de l'objecte a cercar.
	 * @return El primer objecte que té l'identificador igual que el paràmetre identifier; o null si no se'n troba cap.
	 */
	protected E getIdentifiedObject(String identifier) {
		E result=null;
		try {
			result=getIdentifiedObject(identifier, null);
		} catch (EIException e) {
			// Donat que cridem amb el tercer paràmetre null, mai es llençar� l'excepció i mai es passar� per aqu�.
			// només es tracta doncs d'una obligació imposada pel compilador de Java
		}
		return result;
	}

 	
	public Iterador<E> elements(String exceptionMessage) throws EIException {
		if (this.estaBuit()) throw new EIException(exceptionMessage);
		return this.elements();
	}

}
