package uoc.ded.practica;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class FactoryTrial4C19 {


    public static Trial4C19 getTrial4C19() throws Exception {
        Trial4C19 trial4C19;
        trial4C19 = new Trial4C19Impl();

        ////
        //// USERS
        ////
        trial4C19.addUser("idUser1", "Joan", "Simo");
        trial4C19.addUser("idUser2", "Pep", "Lluna");
        trial4C19.addUser("idUser3", "Isma", "Ferra");
        trial4C19.addUser("idUser4", "Marc", "Quilez");
        trial4C19.addUser("idUser5", "Armand", "Morata");
        trial4C19.addUser("idUser6", "Jesus", "Sallent");
        trial4C19.addUser("idUser7", "Anna", "Casals");
        trial4C19.addUser("idUser8", "Mariajo", "Padró");
        trial4C19.addUser("idUser9", "Agustí", "Padró");
        trial4C19.addUser("idUser10", "Pepet", "Marieta");


        ////
        //// Trial
        ////
        trial4C19.addTrial(1, "Description 1");
        trial4C19.addTrial(2, "Description 2");
        trial4C19.addTrial(15, "Description 15");
        trial4C19.addTrial(8, "Description 8");
        trial4C19.addTrial(20, "Description 20");
        trial4C19.addTrial(18, "Description 18");


        ////
        //// QuestionGroups
        ////
        trial4C19.addQuestionGroup("habits",Trial4C19.Priority.MEDIUM );
        trial4C19.addQuestionGroup("wellness", Trial4C19.Priority.LOWER);
        trial4C19.addQuestionGroup("symptoms",Trial4C19.Priority.HIGH );

        ////
        //// Questions
        ////
        trial4C19.addQuestion("idQuestion1a", "Can't sleep because of coughing?", Trial4C19.Type.TEXT_PLAIN, null, "symptoms");
        trial4C19.addQuestion("idQuestion1b", "Do you have pain in the chest or upper abdomen ?", Trial4C19.Type.TEXT_PLAIN, null,"symptoms");
        trial4C19.addQuestion("idQuestion1c", "do you have a headache?", Trial4C19.Type.TEXT_PLAIN, null, "symptoms");

        trial4C19.addQuestion("idQuestion2a", "How long you wash your hands?", Trial4C19.Type.TEXT_PLAIN, null, "habits");
        String[] choices = {"cloth masks", "Surgical masks", "N95 masks"};
        trial4C19.addQuestion("idQuestion2b", "What kind of mask are you using ?", Trial4C19.Type.LIKERT, choices, "habits");
        trial4C19.addQuestion("idQuestion2c", "Good hydration is crucial for optimal health. How do you hydrate in one day?", Trial4C19.Type.TEXT_PLAIN, null, "habits");

        trial4C19.addQuestion("idQuestion3a", "do you have pain?",Trial4C19.Type.TEXT_PLAIN, null, "wellness");
        trial4C19.addQuestion("idQuestion3b", "do you feel itchy?",Trial4C19.Type.TEXT_PLAIN, null, "wellness");
        trial4C19.addQuestion("idQuestion3c", "do you have a skin rash?",Trial4C19.Type.TEXT_PLAIN, null, "wellness");

        ////
        //// Assign QuestionGroups
        ////
        trial4C19.assignQuestionGroup2Trial("habits", 1);
        trial4C19.assignQuestionGroup2Trial("wellness", 1);
        trial4C19.assignQuestionGroup2Trial("symptoms", 1);

        trial4C19.assignQuestionGroup2Trial("habits", 2);

        ////
        //// Assign Users
        ////
        trial4C19.assignUser2Trial(1, "idUser1");
        trial4C19.assignUser2Trial(1, "idUser2");
        trial4C19.assignUser2Trial(1, "idUser3");

        trial4C19.assignUser2Trial(2, "idUser4");



        return trial4C19;
    }



}