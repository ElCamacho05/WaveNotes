package database.connections;

import java.io.FileInputStream;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

public class connection {
    public static FirebaseApp getFirebaseConnection() {
        if (FirebaseApp.getApps().isEmpty()) {
            try {
                FileInputStream serviceAccount = new FileInputStream("/home/camachess/Escritorio/UNI/S_8/DAW/proyecto/WaveNotes/wavenotes-b3cec-firebase-adminsdk-fbsvc-867eaa3d46.json");

                FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .setStorageBucket("wavenotes-b3cec.firebasestorage.app")
                    .build();

                return FirebaseApp.initializeApp(options);
            } catch (Exception e) {
                System.out.println("-- (Connection) No se pudo establecer la conexion con Firebase: " + e.toString());
            }
        }
        return FirebaseApp.getInstance();
    }
}
