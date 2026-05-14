package database.dataAccessObjects;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.google.firebase.cloud.FirestoreClient;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;

import database.connections.connection;
import model.PracticeModel;

public class PracticesDAO {
    public static UUID createPractice(PracticeModel practice) {
        FirebaseApp app = connection.getFirebaseConnection();
        Firestore db = FirestoreClient.getFirestore();
        
        UUID practiceID = UUID.randomUUID();

        Map<String, Object> data = new HashMap<>();

        data.put("TitlePractice", practice.getTitlePractice());
        data.put("PracticeID", practiceID);

        db.collection("practicas").document().set(data);


        return practiceID;
    }
}
