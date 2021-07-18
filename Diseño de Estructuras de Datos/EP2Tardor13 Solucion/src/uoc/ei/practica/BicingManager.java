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
}
