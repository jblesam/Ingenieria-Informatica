package uoc.ei.practica;


import  java.io.*;
import  java.util.*;
import  java.lang.reflect.Method;
import  java.text.SimpleDateFormat;

/**
 * Classe encarregada de llegir un joc de proves escrites en un fitxer de
 * text, d'executar-les i d'escriure els resultats a un altre fitxer també
 * <i>plain text</i>.
 * Els noms per defecte dels fitxers <i>plain text</i> són <code>in.txt
 * </code> i <code>out.txt</code>.
 * Admet String's, tipus de dades primitius i dates (java.util.Date) en
 * format "dd-MM-yyyy HH:mm:ss"
 *
 * @author   UOC. Estructura de la Informació. Equip docent
 * @version  Primavera 2010
 */
public class Test
{
   /** Salt de línia de la plataforma. */
   public static final String LS = System.getProperty("line.separator");

   /**
    * Separador del nom del mètode i dels seus paràmetres, al fitxer
    * d'entrada.
    */
   public static final String TOKEN = ",";

   /**
    * S�mbol que es posa al principi d'una línia del fitxer d'entrada per
    * indicar que es tracta d'un comentari.
    */
   public static final String REMARK = "#";

   /** Format que han de tenir els paràmetres de tipus java.util.Date. */
   public static final String DATE = "dd-MM-yyyy HH:mm:ss";

   /** Instància de la classe gestora. */
   Object gestor;

   /** Mètodes de la classe gestora. */
   Map<Operation, Method> operations;

   /** Nom del fitxer d'entrada amb el joc de proves. */
   private String inFile = "in.txt";

   /** Nom del fitxer de sortida amb els resultats de les proves. */
   private String outFile = "out.txt";

   /** Lector del fitxer d'entrada. */
   private BufferedReader in;

   /** Escriptor del fitxer de sortida. */
   private PrintStream out;

   /**
    * Constructor amb dos paràmetres.
    * @param gestor  nom complet de la classe gestora (package.name)
    * @param args  array amb el nom dels fitxers d'entrada i de sortida;
    *              si no hi ha dos arguments, s'usen els noms per defecte:
    *              <code>in.txt</code> i <code>out.txt</code>
    */
   public Test(String gestor, String[] args)
   {
      try
      {
         Class<? extends Object> clazz = Class.forName(gestor);
         this.gestor = clazz.newInstance();
         loadMethods(clazz.getMethods());
      }
      catch (Exception ex)
      {
         System.err.println("ERROR: en instanciar la classe gestora (" +
                             gestor + ")");
         ex.printStackTrace();
         System.exit(-1);
      }

      if (args.length == 2) { inFile = args[0];  outFile = args[1]; }

      try
      {
         in = new BufferedReader(new FileReader(args[0]));
         out = new PrintStream(new FileOutputStream(args[1]));
      }
      catch (Exception ex)
      {
         System.err.println("ERROR: als fitxers d'entrada/sortida (" +
                             inFile + " o " + outFile + ")");
         ex.printStackTrace();
         System.exit(-1);
      }
   }

   /**
    * Mètode que carrega les operacions de la classe gestora a una taula.
    * No hi ha suport per a mètodes homònims amb el mateix nombre de
    * paràmetres.
    * @param methods  array amb els mètodes de la classe gestora
    */
   private void loadMethods(Method[] methods)
   {
      operations = new Hashtable<Operation,Method>();
      for(Method m: methods)
      {
         Operation op = new Operation(m);
         if (operations.containsKey(op))
         {
            System.err.println("ERROR: No hi ha suport per a metodes " +
               "homonims amb el mateix nombre de parametres:" + LS + m);
            System.exit(-1);
         }
         operations.put(op, m);
      }
   }

   /**
    * Mètode que llegeix el fitxer d'entrada i executa les operacions
    * indicades de la classe gestora, amb els seus paràmetres.
    */
   public void execute()
   {
      try
      {
         String line;
         while ((line = in.readLine()) != null)
         {
            line = line.trim();
            if ( line.length() == 0 || line.startsWith(REMARK) )
               out.println(line);
            else
               executeOperation(line);
         }
      }
      catch (IOException ioex)
      {
         System.err.println("ERROR: en llegir el fitxer d'entrada (" +
                             inFile + ")");
         ioex.printStackTrace();
         System.exit(-1);
      }
   }

   /**
    * Mètode que invoca una operació amb els seus arguments.
    * @param line  nom del mètode i valor dels seus paràmetres, en format
    *        String, separats per un delimitador (Test.TOKEN)
    * @return  resultat que retorna el mètode
    */
   private Object executeOperation(String line)
   {
      Object result = null;
      String[] tokens = line.split(TOKEN);
      Operation op = new Operation(tokens);
      Method method = operations.get(op);
      if (method == null)
      {
         out.println("ERROR: El metode " + op + " no existeix");
      }
      else
      {
         Object[] args = getParams(method, tokens);
         try
         {
            out.println(op);
            result = method.invoke(gestor, args);
            if (result == null)  out.println("void");
            else  printResult(result);
         }
         catch (Exception ex)
         {
            if (ex.getCause() instanceof EIException)
            {
               out.println("ERROR: " + ex.getCause().getMessage());
            }
            else
            {
               System.err.println("ERROR: en invocar el metode " + op);
               ex.printStackTrace();
               System.exit(-1);
            }
         }
      }
      return  result;
   }

   /**
    * Métode que retorna, mitjançant un array d'objectes, els paràmetres
    * de l'operació considerada.
    * @param method  mètode amb la definició dels seus paràmetres
    * @param tokens  nom del mètode i valor dels seus paràmetres en
    *        format String
    * @return  un array amb el valor dels paràmetres convertit al tipus de
    *          dades corresponent
    */
   private Object[] getParams(Method method, String[] tokens)
   {
      Class<? extends Object>[] paramTypes = method.getParameterTypes();
      Object[] result = new Object[paramTypes.length];
      for (int i = 0; i < paramTypes.length; i++)
      {
         String paramType = paramTypes[i].getName();
         result[i] = wrapParam(tokens[i+1].trim(), paramType);
      }
      return  result;
   }

   /**
    * Mètode que retorna el valor d'un paràmetre emmotllat (wrapped)
    * d'acord amb el tipus de dades considerat.
    * @param param  valor del paràmetre en format String
    * @param type  nom del tipus de dades que correspon al paràmetre
    * @return  objecte amb valor del paràmetre emmotllat al tipus de dades
    */
   private Object wrapParam(String param, String type)
   {
      Object result = param;
      try
      {
         if (type.equals("boolean")     ||
            type.equals("java.lang.Boolean"))
            result = new Boolean(param);
         else if (type.equals("byte")   ||
            type.equals("java.lang.Byte"))
            result = new Byte(param);
         else if (type.equals("short")  ||
            type.equals("java.lang.Short"))
            result = new Short(param);
         else if (type.equals("int")    ||
            type.equals("java.lang.Integer"))
            result = new Integer(param);
         else if (type.equals("long")   ||
            type.equals("java.lang.Long"))
            result = new Long(param);
         else if (type.equals("float")  ||
            type.equals("java.lang.Float"))
            result = new Float(param);
         else if (type.equals("double") ||
            type.equals("java.lang.Double"))
            result = new Double(param);
         else if (type.equals("char")   ||
            type.equals("java.lang.Character"))
            result = new Character(param.charAt(0));
         else if (type.equals("java.util.Date"))
         {
            SimpleDateFormat sdf = new SimpleDateFormat(DATE);
            result = sdf.parse(param);
         }
      }
      catch (NumberFormatException nfex)
      {
         out.println("ERROR: S'esperava un " + type + " i hi ha "+ param);
      }
      catch (java.text.ParseException pex)
      {
         out.println("ERROR: S'esperava un format " + DATE + " i hi ha " +
                     param);
      }
      return  result;
   }

   /**
    * Mètode que imprimeix un resultat al fitxer de sortida.
    * @param result  resultat no nul i no buit que es vol imprimir
    */
   private void printResult(Object result)
   {
      if (result instanceof uoc.ei.tads.Iterador<?>)
      {
         for (uoc.ei.tads.Iterador<?> it = (uoc.ei.tads.Iterador<?>)result;
                                   it.hiHaSeguent(); )
         {
            out.println(it.seguent());
         }
      }
      else  out.println(result.toString());
   }
}

/**
 * Classe auxiliar per poder distingir mètodes homònims quan tenen
 * diferent nombre d'arguments.
 *
 * @author   UOC. Estructura de la Informació. Equip docent
 * @version  Primavera 2007
 */
class Operation
{
   /** Nom del mètode. */
   private final String name;

   /** Nombre de paràmetres del mètode. */
   private final int count;

   /** Signatura del mètode. */
   private String head = "";

   /**
    * Constructor amb un paràmetre.
    * @param method  informació sobre el mètode considerat
    */
   public Operation(Method method)
   {
      name  = method.getName();
      count = method.getParameterTypes().length;
   }

   public String getName() {
	return this.name;
}

/**
    * Constructor amb un paràmetre.
    * @param tokens  nom del mètode i valor dels seus paràmetres en
    *        format String
    */
   public Operation(String[] tokens)
   {
      name  = tokens[0];
      count = tokens.length - 1;
      String args = "";
      for (int i = 1; i < tokens.length; i++)
      {
         args += (", " + tokens[i].trim());
      }
      if (args.length() > 1)  args = args.substring(2); // esborra 1a coma

      head = name + '(' + args + ')';
   }

   /**
    * Sobreescriu el mètode equals definit a Object.
    * @param obj  objecte de la mateixa classe o descendents
    * @return  cert, si l'objecte rebut és no nul, de la mateixa classe i
    *          té el mateix nombre de paràmetres; fals, altrament
    */
   public boolean equals(Object obj)
   {
      boolean result = false;
      if (obj != null && obj instanceof Operation)
      {
         Operation other = (Operation)obj;
         result = name.equals(other.name) && (count == other.count);
      }
      return  result;
   }

   /**
    * Sobreescriu el mètode hashCode definit a Object.
    * @return  un codi de dispersió per a l'objecte
    */
   public int hashCode() { return  name.hashCode(); }

   /**
    * Mètode que redefineix la conversió de l'objecte a String.
    * @return  cadena de caràcters amb el nom de l'operació i el nombre
    *          de paràmetres, o el seu valor si és conegut.
    */ 
   public String toString()
   {
      return  (head.length() == 0) ?
              (name + " amb " + count + " arguments") : head;
   }
}
