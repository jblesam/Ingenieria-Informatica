package uoc.ei.practica;

import java.util.Calendar;
import java.util.Date;

/**
 * mètode que representa un Servei en el sistema
 *
 */
public class Service {

	/**
	 * usuari que realitza el servei
	 */
	private User user;
	
	/**
	 * data d'inici del servei
	 */
	private Date startTime;
	
	/**
	 * data de final del servei
	 */
	private Date endTime;
	
	/**
	 * estació d'origen
	 */
	private Station fromStation;
	
	/**
	 * estació destí
	 */
	private Station toStation;

	public Service(User user, Station fromStation, Date startTime) {
		this.user=user;
		this.startTime=startTime;
		this.fromStation=fromStation;
	}

	/**
	 * mètode que indica el fi del servei
	 * @param toStation estació destí
	 * @param endTime data en la que es retorna la bicicleta
	 * @return
	 */
	public long finish(Station toStation, Date endTime) {
		this.toStation=toStation;
		this.endTime=endTime;
		
		Calendar start = Calendar.getInstance();
		start.setTime(startTime);
		
		Calendar end = Calendar.getInstance();
		end.setTime(endTime);
		
		return (end.getTimeInMillis()-start.getTimeInMillis());
	}

	/**
	 * mètode que proporciona una representació en forma d'un String del Servei
	 */
	public String toString() {
		StringBuffer sb=new StringBuffer();
		sb.append("user: ").append(this.user.getName()).append(" ("+this.user.getIdentifier()+") ").append(Messages.LS);
		sb.append("from: ").append(this.fromStation.getIdentifier()).append(Messages.LS);
		if (this.toStation!=null) sb.append("to: ").append(this.toStation.getIdentifier()).append(Messages.LS);
		
		sb.append("startTime: ").append(DateUtils.format(this.startTime)).append(Messages.LS);
		if (this.endTime!=null) sb.append("endTime: ").append(DateUtils.format(this.endTime)).append(Messages.LS);	
		
		return sb.toString();
		
	}


	/**
	 * mètode que retorna l'usuari que realitza el servei
	 * @return
	 */
	public User getUser() {
		return this.user;
	}
	
}
