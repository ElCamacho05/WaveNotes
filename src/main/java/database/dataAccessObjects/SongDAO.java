package database.dataAccessObjects;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.google.cloud.firestore.Firestore;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.Bucket;
import com.google.firebase.cloud.FirestoreClient;
import com.google.firebase.cloud.StorageClient;

import model.SongModel;

public class SongDAO {
    
    public static SongModel uploadAndRegisterSong(SongModel audio) throws Exception {
        try {
            audio.setAudioIDAudio(UUID.randomUUID().toString());

            String storagePath = "Songs/" + audio.getAudioIDAudio() + "_" + audio.getOriginalName();

            Bucket bucket = StorageClient.getInstance().bucket();
            Blob blob = bucket.create(storagePath, audio.getSongBytes(), "audio/mpeg");

            String downloadUrl = "https://firebasestorage.googleapis.com/v0/b/" + bucket.getName() + "/o/" + 
                                URLEncoder.encode(storagePath, "UTF-8") + "?alt=media";

            audio.setUrlAudio(downloadUrl);

            Firestore db = FirestoreClient.getFirestore();
            db.collection("Songs").document(audio.getAudioIDAudio()).set(audio);
            System.out.println("// (SongDAO) Cancion subida correctamente " + audio.getOriginalName() + ", " + audio.getUrlAudio());

        } catch (Exception e) {
            System.out.println("!! (SongDAO) Error al subir cancion " + audio.getOriginalName());
        }
        
    return audio;
    }
}