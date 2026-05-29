package database.dataAccessObjects;

import com.google.cloud.firestore.Firestore;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.Bucket;
import com.google.firebase.cloud.FirestoreClient;
import com.google.firebase.cloud.StorageClient;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class SongDAO {
    
    public static String uploadAndRegisterSong(byte[] fileBytes, String originalName, double length) throws Exception {
        String songID = UUID.randomUUID().toString();
        String storagePath = "Songs/" + songID + "_" + originalName;

        Bucket bucket = StorageClient.getInstance().bucket();
        Blob blob = bucket.create(storagePath, fileBytes, "audio/mpeg");

        String downloadUrl = "https://firebasestorage.googleapis.com/v0/b/" + bucket.getName() + "/o/" + 
                             URLEncoder.encode(storagePath, "UTF-8") + "?alt=media";

        Firestore db = FirestoreClient.getFirestore();
        Map<String, Object> songData = new HashMap<>();
        songData.put("audioIDAudio", songID);
        songData.put("urlAudio", downloadUrl);
        songData.put("lengthAudio", length);
        songData.put("originalName", originalName);

        db.collection("Songs").document(songID).set(songData);

        return songID;
    }
}