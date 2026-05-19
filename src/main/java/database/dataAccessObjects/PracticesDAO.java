package database.dataAccessObjects;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.cloud.FirestoreClient;

import database.connections.connection;
import model.PracticeModel;

public class PracticesDAO {
    
    public static String createPractice(String uid, PracticeModel practice, String songID) {
        FirebaseApp app = connection.getFirebaseConnection();
        Firestore db = FirestoreClient.getFirestore();
        
        String practiceID = UUID.randomUUID().toString();

        Map<String, Object> data = new HashMap<>();
        data.put("TitlePractice", practice.getTitlePractice());
        data.put("DatePractice", practice.getCreationPractice());
        data.put("ScorePractice", practice.getScorePractice());
        data.put("AccuracyPractice", practice.getAccuracyPractice());
        data.put("SongIDPractice", songID);
        data.put("TrackInstrumentPractice", practice.getInstrumentPractice());
        data.put("NotesPractice", practice.getNotesPractice());

        db.collection("Users").document(uid)
            .collection("Practices").document(practiceID)
            .set(data);

        return practiceID;
    }
}
