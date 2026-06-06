package database.dataAccessObjects;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
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
        System.out.println("-- (PracticesDAO) Obteniendo practicas");
        List<PracticeModel> practices = new ArrayList<>();
        
        connection.getFirebaseConnection();
        Firestore db = FirestoreClient.getFirestore();

        if (uid.isEmpty() || uid.equals("")) {
            System.out.println("!! (PracticesDAO) No hay id de usuario valido");
        }

        try {
            System.out.println("!! (PracticesDAO) Buscando");
            ApiFuture<QuerySnapshot> futurePractices = db.collection("Users").document(uid).collection("Practices").get();
            
            List<QueryDocumentSnapshot> documentsPractices = futurePractices.get().getDocuments();

            for (QueryDocumentSnapshot document : documentsPractices) {
                PracticeModel practice = document.toObject(PracticeModel.class);
                
                if (practice != null) {
                    practices.add(practice);
                }
            }
            System.out.println("!! (PracticesDAO) Practicas obtenidas");
            return practices;

        } catch (Exception e) {
            System.out.println("!! Error obteniendo prácticas de Firestore: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public static PracticeModel getPracticeByID(String uid, String IDPractice) {
        if (uid == null || uid.trim().isEmpty() || IDPractice == null || IDPractice.trim().isEmpty()) {
            System.out.println("!! (PracticesDAO) Error: UID o IDPractice inválidos para la búsqueda.");
            return null;
        }

        System.out.println("-- (PracticesDAO) Buscando practica : " + IDPractice);
        
        connection.getFirebaseConnection();
        Firestore db = FirestoreClient.getFirestore();

        try {
            ApiFuture<DocumentSnapshot> futureDocument = db.collection("Users").document(uid)
                    .collection("Practices").document(IDPractice).get();
            
            DocumentSnapshot document = futureDocument.get();
            
            if (document.exists()) {
                System.out.println("// (PracticesDAO) Practica encontrada");
                return document.toObject(PracticeModel.class);
            } else {
                System.out.println("!! (PracticesDAO) Practica inexistente");
                return null;
            }

        } catch (Exception e) {
            System.out.println("!! (PracticesDAO) Error al obtener la practica: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static void deletePractice(String uid, String IDPractice) {
        if (uid == null || uid.trim().isEmpty() || IDPractice == null || IDPractice.trim().isEmpty()) {
            System.out.println("!! (PracticesDAO) Practica o ID de usuario invalidos.");
            return;
        }

        System.out.println("-- (PracticesDAO) Eliminando la practica: " + IDPractice);
        
        connection.getFirebaseConnection();
        Firestore db = FirestoreClient.getFirestore();

        try {
            db.collection("Users").document(uid)
                .collection("Practices").document(IDPractice)
                .delete();

            System.out.println("// (PracticesDAO) Practica eliminada de Firestore");
        } catch (Exception e) {
            System.out.println("!! (PracticesDAO) Error al eliminar la practica: " + e.getMessage());
            e.printStackTrace();
        }
    }
}