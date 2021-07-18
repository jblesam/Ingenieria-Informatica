package uoc.ei.practica;

import java.util.Comparator;

import uoc.ei.tads.Contenidor;
import uoc.ei.tads.CuaAmbPrioritat;

/**
 * mètode que representa una estació del sistema
 *
 */
public class Station {

	/**
	 * comparador de les bicicletes d'una estació basat en el temps d'us.
	 */
	private static final Comparator BICYCLE_COMPARATOR = new Comparator<Bicycle>(){

		@Override
		public int compare(Bicycle bicycle1, Bicycle bicycle2) {
			return (int)(bicycle1.time()-bicycle2.time());
		}
		
	};
	
	/**
	 * identificador de l'estació
	 */
	private int stationId;
	
	/**
	 * coordenada GPS
	 */
	private long latitude;

	/**
	 * coordenada GPS
	 */
	private long longitude;
	
	/**
	 * cua de les bicicletes d'una estació
	 */
	private CuaAmbPrioritat<Bicycle> bicycles;
	
	/**
	 * nombre de parking
	 */
	private int nParkings;
	
	/**
	 * activitat de l'estació
	 */
	private int activity;


	public Station(int stationId, long latitude, long longitude, int nParkings) {
		this.stationId=stationId;
		this.set(latitude, longitude, nParkings);
		this.bicycles=new CuaAmbPrioritat(BICYCLE_COMPARATOR);
	}

	public void set(long latitude, long longitude, int nParkings) {
		this.latitude = latitude;
		this.longitude= longitude;
		this.nParkings=nParkings; 
	}

	/**
	 * mètode que afegeix una bicicleta a una estació
	 * @param bicycle
	 * @throws EIException
	 */
	public void addBicycle(Bicycle bicycle) throws EIException {
		if (this.bicycles.nombreElems()>=this.nParkings) throw new EIException(Messages.MAX_NUMBER_OF_BICYCLES);
		else this.bicycles.encuar(bicycle);
	}

	/** 
	 * mètode que proporciona les bicicletes de l'estació
	 * @return
	 */
	public Contenidor<Bicycle> bicycles() {
		return this.bicycles;
	}
	
	
	/**
	 * mètode que proporciona una bicicleta disponible. Aquesta bicicleta serà 
	 * la bicicleta que s'hagi "usat" menys 
	 * @return
	 */
	public Bicycle getBicycle() {
		Bicycle bicycle=null;
		if (!this.bicycles.estaBuit()) {
			bicycle = this.bicycles.desencuar();
		}
		return bicycle;
	}

	/**
	 * mètode que proporciona una representació en forma d'un string d'una estació
	 */
	public String toString() {
		StringBuffer sb=new StringBuffer("id: "+this.stationId).append(Messages.LS);
		sb.append("latitude: ").append(this.latitude).append(Messages.LS);
		sb.append("longitude: ").append(this.longitude).append(Messages.LS);
		sb.append("nParkings: ").append(this.nParkings).append(Messages.LS);
		sb.append("bicycles: ").append(this.bicycles.nombreElems()).append(Messages.LS);
		
		return sb.toString();
		
	}

	/**
	 * mètode que proporciona l'identificador de l'estació
	 * @return identificador de l'estació
	 */
	public int getIdentifier() {
		return this.stationId;
	}
	
	/**
	 * mètode que incrementa l'activitat d'una estació
	 */
	public void incActivity() {
		this.activity++;
	}

	/**
	 * mètode que proporciona l'activitat d'una estació
	 * @return activitat d'una estació
	 */
	public int activity() {
		return this.activity;
	}
}