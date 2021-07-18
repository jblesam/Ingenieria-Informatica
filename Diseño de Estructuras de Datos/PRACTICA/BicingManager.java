package uoc.ei.practica;

import java.util.Date;

import uoc.ei.tads.Iterador;

/** 
 * Definició del TAD de gestió del servei de bicing
 */
public interface BicingManager {

	
	public static final int S = 20;
	
	public static final int B = 150;
	
	/**
	 * Mètode que afegeix una estació al sistema de gestió de bicicletes. En cas que l'estació ja existeixi 
	 * es modificaran les seves dades: latitude, longitude, nParkings
	 * @param stationId identificador de l'estació
	 * @param latitude posició GPS
	 * @param longitude posició GPS
	 * @param nParkings nombre de bicicletes que pot gestionar l'estació
	 */
	public void addStation(int stationId, long latitude, long longitude, int nParkings) throws EIException;


	/**
	 * mètode que proporciona un iterador amb les estacions del sistema.
	 * @return retorna l'iterador
	 * @throws EIException llença una excepció en el cas que no hi hagi cap element
	 */
	public Iterador<Station> stations() throws EIException;
	

	
	/**
	 * mètode que afegeix una bicicleta associada a una estació. 
	 * @param bicycleId identificador únic d'una bicicleta
	 * @param model model de la bicicleta
	 * @param stationId identificador de l'estació on estarà ubicada la bicileta
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- Si una bicicleta ja existeix en el sistema.
	 * 2.- L'estació no existeixi
	 * 3.- Es superi el màxim nombre de bicicletes sobre una estació
	 */
	public void addBicycle(String bicycleId, String model, int stationId) throws EIException;
	
	
	/**
	 * Mètode que proporciona les bicicletes disponibles d'una estació
	 * @return retorna un iterador amb les bicicletes d'una estació
	 * @throws EIException llença una excepció en el següents casos:
	 * 1.- l'estació no existeix 
	 * 2.- No hi hagi bicicletes en aquesta estació
	 */
	public Iterador<Bicycle> bicyclesByStation(int stationId) throws EIException;
	
	
	/**
	 * mètode que proporciona totes les bicicletes del sistema.
	 * @return retorna un iterador amb totes les bicicletes del sistema
	 * @throws EIException llença una excepció en el cas que l'iterador no tingui cap element.
	 */
	public Iterador<Bicycle> bicycles() throws EIException;
	
	/**
	 * mètode que afegeix un usuari en el sistema. En cas que l'usuari ja existeixi modifica les seves dades.
	 * @param userId identificador de l'usuari
	 * @param name nom de l'usuari
	 */
	public void addUser(String userId, String name);
	
	/**
	 * mètode que proporciona tots els usuaris del sistema.
	 * @return retorna un iterador amb tots els usuaris del sistema
	 * @throws EIException llença una excepció en el cas que l'iterador no tingui cap element.
	 */
	public Iterador<User> users() throws EIException;
	
	
	/**
	 * Mètode que permet agafar una bicicleta disponible d'una estació. De entre totes les 
	 * bicicletes (disponibles) d'una estació es proporcionarà la que s'hagi utilitzat "menys temps" 
	 * @param userId identificador de l'usuari que demana la bicicleta
	 * @param stationId identificador de l'estació de bicicletes
	 * @param dateTime data en la que s'obté la bicicleta
	 * @return retorna una bicicleta que no estigui avariada i que s'hagi utilitzat menys. En cas que hi hagin 
	 * varies bicicletes amb el mateix temps d'utilització es proporcionarà qualsevol.
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- L'usuari no existeixi
	 * 2.- L'estació no existeixi
	 * 3.- L'usuari ja té actualment una bicicleta
	 * 4.- No hi hagi cap bicicleta disponible
	 */
	public Bicycle getBicycle(String userId, int stationId, Date dateTime) throws EIException;
	
	
	
	/**
	 * Mètode que permet retorna una bicicleta que prèviament ha estat agafada prèviament.
	 * @see #getBicycle  
	 * @param bicycleId identificador de la bicicleta a retornar
	 * @param stationId identificador de l'estació sobre la que es vol retornar la bicicleta
	 * @param dateTime
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- La bicicleta no existeixi
	 * 2.- L'estació no existeixi
	 * 3.- L'estació està plena i no tingui espais lliures.
	 */
	public void returnBicycle(String bicycleId, int stationId, Date dateTime) throws EIException;
	
	
	
	/**
	 * mètode que proporciona els serveis que ha realitzat una determonada bicicleta
	 * @param bicycleId identificador de la bicicleta
	 * @return retorna els serveis
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- La bicicleta no existeixi
	 * 2.- La bicicleta no hagi fet cap servei
	 */
	public Iterador<Service> servicesByBicycle(String bicycleId) throws EIException;
	
	
	/**
	 * mètode que proporciona l'estació més activa
	 * @return l'estació més activa
	 * @throws EIException llença una excepció en el cas que no hi hagi cap estació
	 */
	public Station mostActiveStation() throws EIException;
	
	/**
	 * mètode que proporciona l'usuari més actiu
	 * @return l'usuari més actiu
	 * @throws EIException llença una excepció en el cas que no hi hagi cap usuari que hagi fet activitat
	 */
	public User mostActiveUser() throws EIException;
	
	// NEW OPERARTIONS IN PRAC
	
	/**
	 * Mètode que afegeix un nou operari al sistema de gestió de bicicletes. 
	 * De cada operari en sabrem el seu codi identificador (string amb el DNI), i el seu nom.
	 * @param dni DNI de l'operari
	 * @param name Nom de l'operari
	 */
	public void addWorker(String dni, String name);
	
	/**
	 * mètode que proporciona un iterador amb els operaris del sistema.
	 * @return retorna l'iterador
	 * @throws EIException llença una excepció en el cas que no hi hagi cap element
	 */
	public Iterador<Worker> workers() throws EIException;
	
	/**
	 * Registra una nova incidència d’una bicicleta. 
	 * La incidència estarà en estat pendent d’assignar.
	 * @param bicicleId identificador de la bicicleta
	 * @param description descripció de l’avaria
	 * @param dateTime data/hora de l'avaria
	 * @return l'identificador de la incidència
	 * @throws EIException llença una exceptció en el cas que no hi hagi la bicicleta
	 */
	public int addTicket(String bicicleId, String description, Date dateTime) throws EIException;
	
	/**
	 * mètode que proporciona un iterador amb les incidències del sistema.
	 * @return retorna l'iterador
	 * @throws EIException llença una excepció en el cas que no hi hagi cap element
	 */
	public Iterador<Ticket> tickets() throws EIException;
	
	/**
	 * Assigna una incidència a un operari. 
	 * S’assignarà a l’operari amb menys incidències assignades, i la incidència passarà a estat assignada.
	 * @param ticketId identificador de la incidència
	 * @param dateTime data/hora de l’assignació
	 * @return l’operari assignat a la incidència
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- La incidència no existeixi
	 * 2.- No hi hagi operaris
	 */
	public Worker assignTicket(int ticketId, Date dateTime) throws EIException;
		
	
	/**
	 * Resol una incidència. Rebrem l’identificador de la incidència, una explicació de la reparació i la data/hora. La incidència passarà a estat resolt.
	 * @param ticketId identificador de la incidència
	 * @param desciption explicació de la reparació
	 * @param dateTime data/hora de la reparació
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- La incidència no existeixi
	 * 2.- La incidència no tingui operari assignat
	 */
	public void resolveTicket(int ticketId, String desciption, Date dateTime) throws EIException;
	
	/**
	 * mètode que proporciona un iterador amb les incidències de l'operari.
	 * @param workerId identificador de l'operari
	 * @return retorna l'iterador
	 * @throws EIException llença una excepció si l'operari no té incidències assignades
	 */
	public Iterador<Ticket> ticketsByWorker(String workerId) throws EIException;
	
	/**
	 * mètode que proporciona un iterador amb les incidències de la bicicleta.
	 * @param bicicleId identificador de la bicicleta
	 * @return retorna l'iterador
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- La bicicleta no existeixi
	 * 2.- La bicicleta no tingui incidències assignades
	 */
	public Iterador<Ticket> ticketsByBicycle(String bicycleId) throws EIException;
	
	/**
	 * Consultar quina és l’estació més conflictiva (la que ha registrat més incidències).
	 * @return L'estació més conflictiva.
	 * @throws EIException llença una excepció si no s'ha enregisatrat encara cap incidència
	 */
	public Station mostProblematicStation() throws EIException;
	
	/**
	 * Consulta el nombre de bicicletes aparcades en una estació (que no tinguin una incidència pendent de resoldre).
	 * @param stationId identificador de l'estació
	 * @return el nombre de bicicletes aparcades en una estació (que no tinguin una incidència pendent de resoldre). 
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- L'estació no existeixi
	 * 2.- L'estació no tingui bicicletes aparcades (que no tinguin una incidència pendent de resoldre). 
	 */
	public int getNBicycles(int stationId) throws EIException;
	
	/**
	 * Consulta el nombre de places lliures en una estació.
	 * @param stationId identificador de l'estació
	 * @return el nombre de places lliures. 
	 * @throws EIException llença una excepció en els següents casos:
	 * 1.- L'estació no existeixi
	 * 2.- L'estació no tingui places lliures. 
	 */
	public int getNParkings(int stationId) throws EIException;
	
	/**
	 * Consulta l’estació més propera amb una o més bicicletes lliures a partir d’unes coordenades (latitud, longitud).
	 * @param latitude posició GPS
	 * @param longitude posició GPS
	 * @return l'estació més propera amb una o més bicicletes lliures
	 * @throws EIException llença una excepció si no hi ha cap estació amb bicicletes lliures
	 */
	public Station getClosestBike(long latitude, long longitude) throws EIException;
	
	/**
	 * Consulta l’estació més propera amb una o més places lliures a partir d’unes coordenades (latitud, longitud).
	 * @param latitude posició GPS
	 * @param longitude posició GPS
	 * @return l'estació més propera amb una o més places lliures
	 * @throws EIException llença una excepció si no hi ha cap estació amb places lliures
	 */
	public Station getClosestParking(long latitude, long longitude) throws EIException;
	
}
