package uoc.ei.practica;


/**
 * Classe principal encarregada d'executar un joc de proves provinent d'un
 * fitxer d'entrada. Els resultats s'escriuen a un fitxer de sortida.
 *
 * @author   Equip docent d'Estructura de la Informació de la UOC
 * @version  Spring 2009
 */ 
public class TestPractica  extends Test
{
   /** Constructor amb dos paràmetres. */
   public TestPractica(String gestor, String[] args)
   {
      super(gestor, args);
   }
 
   /**
    * Mètode d'inici d'execució (programa principal).
    * 1.- S'ha d'instanciar una prova associada a un gestor
    * 2.- Execució de la prova.
    */
   public static void main(String[] args)
   {
      Test p;
      {
         p = new TestPractica("uoc.ei.practica.BicingManagerImpl", args);
         p.execute();
      }
   }
}
