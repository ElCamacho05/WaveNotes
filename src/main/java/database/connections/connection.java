package database.connections;

import java.io.InputStream;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

public class connection {
    public static FirebaseApp getFirebaseConnection() {
        if (FirebaseApp.getApps().isEmpty()) {
            try {
                GoogleCredentials credentials;
                
                InputStream serviceAccount = connection.class.getClassLoader()
                    .getResourceAsStream("wavenotes-b3cec-firebase-adminsdk-fbsvc-867eaa3d46.json");
                
                    
                if (serviceAccount != null) {   // local
                    credentials = GoogleCredentials.fromStream(serviceAccount);
                } else {    // produccion
                    credentials = GoogleCredentials.getApplicationDefault();
                }

                FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(credentials)
                    .setStorageBucket("wavenotes-b3cec.firebasestorage.app")
                    .build();

                return FirebaseApp.initializeApp(options);

            } catch (Exception e) {
                System.out.println("-- (Connection) No se pudo establecer la conexion con Firebase: " + e.toString());
                System.out.println(e);
            }
        }
        return FirebaseApp.getInstance();
    }
}