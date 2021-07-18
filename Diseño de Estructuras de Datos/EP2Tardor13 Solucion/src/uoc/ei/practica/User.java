package uoc.ei.practica;

/**
 * mètode que representa un usuari en el sistema
 *
 */
public class User extends IdentifiedObject {
	
	/** 
	 * nom de l'usuari
	 */
	private String name;
	
	/**
	 * apuntador al servei actual de l'usuari
	 */
	private Service currentService;

	/**
	 * activitat de l'usuari
	 */
	private int activity;
	

	public User(String userId, String name) {
		super(userId);
		this.set(name);
		this.activity=0;
	}

	public void set(String name) {
		this.name=name;
	}

	
	/**
	 * mètode que proporciona una representación en forma d'un String d'un usuari
	 */
	public String toString() {
		StringBuffer sb=new StringBuffer(super.toString());
		sb.append("name: ").append(this.name).append(Messages.LS);
		
		return sb.toString();
		
	}

	/**
	 * mètode que proporciona el nom de l'usuari
	 * @return
	 */
	public String getName() {
		return this.name;
	}

	/**
	 * mètode que actualitza el servei actual
	 * @param service el servei actual
	 */
	public void addCurrentService(Service service) {
		this.currentService=service;
	}

	/**
	 * mètode que indica si actualment hi ha un servei actiu
	 * @return
	 */
	public boolean hasCurrentService() {
		return this.currentService!=null;
	}

	/**
	 * mètode que finalitza el servei actual
	 */
	public void finishCurrentService() {
		this.currentService=null;
	}

	/**
	 * mètode que incrementa l'activitat de l'usuari
	 */
	public void incActicity() {
		this.activity++;
	}

	/**
	 * mètode que proporciona l'activitat de l'usuari
	 * @return
	 */
	public int activity() {
		return this.activity;
	}

}
