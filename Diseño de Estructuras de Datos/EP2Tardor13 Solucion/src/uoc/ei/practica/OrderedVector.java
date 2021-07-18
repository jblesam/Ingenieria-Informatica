package uoc.ei.practica;

import java.util.Comparator;

import uoc.ei.tads.ClauValor;
import uoc.ei.tads.ContenidorAfitat;
import uoc.ei.tads.DiccionariVectorImpl;
import uoc.ei.tads.Iterador;
import uoc.ei.tads.IteradorVectorImpl;
import uoc.ei.tads.Posicio;

/**
 * TAD que implementa un vector ordenat. L'ordenació del vector
 * es determina amb el comparador.
 */
public class OrderedVector<K,V> extends DiccionariVectorImpl<K,V> implements ContenidorAfitat<V>{
	private static final int KEY_NOT_FOUND = -1;

	
	private Comparator<K> comparator;


	public OrderedVector(int max, Comparator<K> comparator) {
		super(max);
		this.comparator = comparator;
	}


	@Override
	public boolean estaPle() {
		return (super.n==super.diccionari.length);
	}

	
	/**
	 * afegeix un element a l'última posició i es reorganitza situant-se a la seva ubicació, segons la 
	 * relació d'ordre definida pel comparador.
	 */
	public void afegir(K clau,V obj) {
		super.afegir(clau, obj);

		// add Key-Value  
		int i=this.n-1;
		
		boolean done=false;
		
		ClauValor kv;
		ClauValor last=this.diccionari[this.n-1];
		
		while (i>=0 && !done) {
			kv = this.diccionari[i]; 
			
			if (this.comparator.compare((K) kv.getClau(), clau)>0) {
				// swap
				this.diccionari[i] = last;
				this.diccionari[i+1]=kv;
				last = this.diccionari[i];				
			}

			i--;
		}
		
	}
	

	/**
	 * mètode que consulta un element sobre el vector ordenat
	 */
	public V consultar(K clau) {
		int pos = this.binary_search(clau, 0, this.n-1);
		return (pos!=this.KEY_NOT_FOUND?this.diccionari[pos].getValor():null);		
	}

	/**
	 * mètode que proporciona un element i retorna una excepció en el cas que no existeix l'element
	 * @param clau
	 * @param bicycleNotFound
	 * @return
	 * @throws EIException
	 */
	public V consultar(K clau, String bicycleNotFound) throws EIException {
		V value=this.consultar(clau);
		if (value==null) throw new EIException(bicycleNotFound);
		return value;
	}

	
	/**
	 * mètode que realitza una cerca dicotòmica
	 * @param key clau a cercar
	 * @param imin posició mínima
	 * @param imax posició màxima
	 * @return
	 */
	private int binary_search(K key, int imin, int imax)
	{
	  // test if array is empty
	  if (imax < imin)
	    // set is empty, so return value showing not found
	    return KEY_NOT_FOUND;
	  else
	    {
	      // calculate midpoint to cut set in half
	      int imid = midpoint(imin, imax);
	 
	      // three-way comparison
	     // if (this.diccionari[imid] > key)
	      
	     // System.out.println("imin: "+imin+" "+imid+" "+imax);
	      
	      if (this.comparator.compare(this.diccionari[imid].getClau(), key)>0)
	        // key is in lower subset
	        return binary_search(key, imin, imid-1);
	      //else if (this.diccionari[imid] < key)
	      else if (this.comparator.compare(this.diccionari[imid].getClau(), key)<0)
	    	  
	        // key is in upper subset
	        return binary_search(key, imid+1, imax);
	      else
	        // key has been found
	        return imid;
	    }
	}
	
	/**
	 * mètode que calcula el punt mig 
	 */
	private int midpoint(int imin, int imax) {
		return imin + ((imax - imin) / 2);
	}


	/**
	 * mètode de prova
	 * @param args
	 */
	public static void main(String[] args) {
		Comparator<String> cmp = new Comparator<String>() {

			@Override
			public int compare(String arg0, String arg1) {
				// TODO Auto-generated method stub
				return arg0.compareTo(arg1);
			}
			
		};
		OrderedVector<String, Integer> v = new OrderedVector<String,Integer>(10, cmp);
		
		v.afegir("09", 9);
		v.afegir("07", 7);
		v.afegir("02", 2);
		v.afegir("03", 3);
		v.afegir("04", 4);
		v.afegir("05", 5);
		v.afegir("06", 6);
		v.afegir("01", 1);

		
		System.out.println("estaPle "+v.estaPle());
		
		for (Iterador<Integer> it = v.elements(); it.hiHaSeguent();) {
			System.out.println(it.seguent());
		}
		
		v.afegir("09", 9);
		v.afegir("10", 10);
		System.out.println("estaPle "+v.estaPle());
		v.afegir("11", 11);
		System.out.println("estaPle "+v.estaPle());
		

		
		
		for (Iterador<Integer> it = v.elements(); it.hiHaSeguent();) {
			System.out.println(it.seguent());
		}

		
		
		System.out.println("1: "+ v.consultar("01"));
		System.out.println("5: "+ v.consultar("05"));
		
		
		System.out.println("11: "+ v.consultar("11"));

		// not found
		System.out.println("1: "+ v.consultar("1"));
		System.out.println("5: "+ v.consultar("5"));

	}


	
	
	
}
