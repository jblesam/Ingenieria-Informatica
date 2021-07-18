package uoc.ei.practica;

import java.util.Date;

import uoc.ei.tads.Contenidor;
import uoc.ei.tads.Iterador;
import uoc.ei.tads.IteradorVectorImpl;

public class BicingManagerImpl implements BicingManager {
	
	/**
	 * vector d'estacions del sistema
	 */
	private Station[] stations;
	private int len;
	
	/**
	 * vector ordenat global de bicicletes del sistema
	 */
	private OrderedVector<String, Bicycle> bicycles;
	
	/**
	 * llista d'usuaris del sistema
	 */
	private IdentifiedList<User> users;
	
	/** 
	 * apuntador a l'estació més activa
	 */
	private Station mostActiveStation;
	
	/**
	 * apuntador a l'usuari més actiu
	 */
	private User mostActiveUser;
	

	public BicingManagerImpl() {
		this.stations= new Station[S];
		this.len=0;
		this.bicycles= new OrderedVector<String, Bicycle>(B, Bicycle.COMP);
		this.users= new IdentifiedList<User>();
		this.mostActiveStation=null;
		this.mostActiveUser=null;
	}


	@Override
	public void addStation(int stationId, long latitude, long longitude,
			int nParkings) throws EIException {
		Station station = this.getStation(stationId);
		
		if (station!=null) station.set(latitude, longitude, nParkings);
		else {
			station = new Station(stationId, latitude, longitude, nParkings);
			this.stations[stationId-1]=station;
			if (len<stationId) len=stationId;
		}
		
		
	}


	public Station getStation(int stationId) {
		Station ret=null;
		if (stationId<=this.len) 
			ret = this.stations[stationId-1];
		return ret;
	}
	
	public Station getStation(int stationId, String message) throws EIException {
		Station station = this.getStation(stationId);
		if (station==null) throw new EIException(message);
		
		return station;
	}
	
	@Override
	public Iterador<Station> stations() throws EIException {
		if (this.len==0) throw new EIException(Messages.NO_STATIONS);
		Iterador<Station> it =  new IteradorVectorImpl(this.stations,this.len,0);

		return it;
	}


	@Override
	public void addBicycle(String bicycleId, String model, int stationId)
			throws EIException {
		
		Bicycle bicycle = this.bicycles.consultar(bicycleId); 
		if (bicycle!=null) throw new EIException(Messages.BICYCLE_ALREADY_EXISTS);
		//else
			
		Station station = this.getStation(stationId, Messages.STATION_NOT_FOUND);
		
		bicycle = new Bicycle(bicycleId, model);
		station.addBicycle(bicycle);
		this.bicycles.afegir(bicycleId, bicycle);
		
	}


	@Override
	public Iterador<Bicycle> bicyclesByStation(int stationId)
			throws EIException {
		Station station = this.getStation(stationId, Messages.STATION_NOT_FOUND);
		Contenidor<Bicycle> bicycles = station.bicycles();
		if (bicycles.estaBuit()) throw new EIException(Messages.NO_BICYCLES);

		
		return bicycles.elements();
	}


	@Override
	public Iterador<Bicycle> bicycles() throws EIException {
		if (this.bicycles.estaBuit()) throw new EIException(Messages.NO_BICYCLES);

		
		return bicycles.elements();
	}


	@Override
	public void addUser(String userId, String name) {
		User user = this.users.getIdentifiedObject(userId);
		
		if (user!=null) user.set(name);
		else {
			user = new User(userId, name);
			this.users.afegirAlFinal(user);
		}
		
	}


	@Override
	public Iterador<User> users() throws EIException {
		if (this.users.estaBuit()) throw new EIException(Messages.NO_USERS);

		
		return users.elements();
	}


	@Override
	public Bicycle getBicycle(String userId, int fromStationId, Date dateTime)
			throws EIException {
		User user = this.users.getIdentifiedObject(userId, Messages.USER_NOT_FOUND);
		Station station = this.getStation(fromStationId, Messages.STATION_NOT_FOUND);
		if (user.hasCurrentService()) throw new EIException(Messages.USER_IS_BUSY);
	
		Bicycle bicycle = station.getBicycle();
		if (bicycle == null) throw new EIException(Messages.NO_BICYCLES);
		
		
		bicycle.startService(user, station, dateTime);
		station.incActivity();
		user.incActicity();
		
		if (this.mostActiveStation==null || this.mostActiveStation.activity()<station.activity()) this.mostActiveStation=station;
		if (this.mostActiveUser==null || this.mostActiveUser.activity()<user.activity()) this.mostActiveUser=user;
		
		return bicycle;
	}


	@Override
	public void returnBicycle(String bicycleId, int toStationId, Date dateTime)
			throws EIException {
		Bicycle bicycle = this.bicycles.consultar(bicycleId, Messages.BICYCLE_NOT_FOUND);

		Station station = this.getStation(toStationId, Messages.STATION_NOT_FOUND);
		station.addBicycle(bicycle);
		
		bicycle.finishService(station, dateTime);
		
	}


	@Override
	public Iterador<Service> servicesByBicycle(String bicycleId)
			throws EIException {
		Bicycle bicycle = this.bicycles.consultar(bicycleId, Messages.BICYCLE_NOT_FOUND);
		Contenidor<Service> services= bicycle.services();
		
		if (services.estaBuit()) throw new EIException(Messages.NO_SERVICES);
		
		return services.elements();
	}


	@Override
	public Station mostActiveStation() throws EIException {
		if (this.mostActiveStation==null) throw new EIException(Messages.NO_STATIONS);
		return this.mostActiveStation;
	}


	@Override
	public User mostActiveUser() throws EIException {
		if (this.mostActiveUser==null) throw new EIException(Messages.NO_USERS);
		return this.mostActiveUser;
	}
	

}
