package database.dataAccessObjects;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.FirebaseApp;
import com.google.firebase.cloud.FirestoreClient;

import database.connections.connection;
import model.PracticeModel;

public class PracticesDAO {
    
    public static String createPractice(String uid, PracticeModel practice) {
        FirebaseApp app = connection.getFirebaseConnection();
        Firestore db = FirestoreClient.getFirestore();
        
        practice.setIDPractice(UUID.randomUUID().toString());

        db.collection("Users").document(uid)
            .collection("Practices").document(practice.getIDPractice())
            .set(practice);

        return practice.getIDPractice();
    }

    public static List<PracticeModel> getPractices(String uid) {
        System.out.println("-- (Practices) Obteniendo practicas");
        List<PracticeModel> practices = new ArrayList<>();
        
        connection.getFirebaseConnection();
        Firestore db = FirestoreClient.getFirestore();

        if (uid.isEmpty() || uid.equals("")) {
            System.out.println("!! (Practices) No hay id de usuario valido");
        }

        try {
            System.out.println("!! (Practices) Buscando");
            ApiFuture<QuerySnapshot> futurePractices = db.collection("Users").document(uid).collection("Practices").get();
            
            List<QueryDocumentSnapshot> documentsPractices = futurePractices.get().getDocuments();

            for (QueryDocumentSnapshot document : documentsPractices) {
                PracticeModel practice = document.toObject(PracticeModel.class);
                
                if (practice != null) {
                    practices.add(practice);
                }
            }
            System.out.println("!! (Practices) Practicas obtenidas");
            return practices;

        } catch (Exception e) {
            System.out.println("!! Error obteniendo prácticas de Firestore: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}