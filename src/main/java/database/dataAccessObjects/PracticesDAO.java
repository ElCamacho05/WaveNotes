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
        
        String practiceID = UUID.randomUUID().toString();

        Map<String, Object> data = new HashMap<>();
        data.put("titlePractice", practice.getTitlePractice());
        data.put("datePractice", practice.getDatePractice());
        data.put("scorePractice", practice.getScorePractice());
        data.put("accuracyPractice", practice.getAccuracyPractice());
        data.put("songIDPractice", practice.getSong().getAudioIDAudio());
        data.put("trackIDPractice", practice.getSong().getAudioIDAudio());
        data.put("trackInstrumentPractice", practice.getTrackInstrumentPractice());
        data.put("notesPractice", practice.getNotesPractice());

        db.collection("Users").document(uid)
            .collection("Practices").document(practiceID)
            .set(data);

        return practiceID;
    }
}
