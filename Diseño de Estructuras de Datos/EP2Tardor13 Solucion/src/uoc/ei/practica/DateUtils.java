package uoc.ei.practica;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Classe auxiliar i d'utilitats sobre dates
 *
 */
public class DateUtils {
	private static SimpleDateFormat SDF = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
	
	public static String format(Date date) {
		return SDF.format(date);
	}
	
	
	public static long diffHours (long diff) {
		return diff / (60*60*1000);
	}
	
}
