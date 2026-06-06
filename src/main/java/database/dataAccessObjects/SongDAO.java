package database.dataAccessObjects;

import java.net.URLEncoder;
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

            String fileName = audio.getAudioIDAudio() + "_" + audio.getOriginalName();
            String storagePath = "Songs/" + fileName;

            // subida a firebase
            Bucket bucket = StorageClient.getInstance().bucket();
            Blob blob = bucket.create(storagePath, audio.getSongBytes(), "audio/mpeg");

            // codificacion para que la url no tenga espacios, sino %20 que los representa
            String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");

            String downloadUrl = "https://firebasestorage.googleapis.com/v0/b/" + bucket.getName() + "/o/Songs%2F" + encodedFileName + "?alt=media";

            audio.setUrlAudio(downloadUrl);

            // guardado de metadatos de la cancion
            Firestore db = FirestoreClient.getFirestore();
            db.collection("Songs").document(audio.getAudioIDAudio()).set(audio);
            
            System.out.println("// (SongDAO) Cancion subida correctamente " + audio.getOriginalName() + ", " + audio.getUrlAudio());

        } catch (Exception e) {
            System.out.println("!! (SongDAO) Error al subir cancion " + audio.getOriginalName() + " : " + e);
        }
        
        return audio;
    }

    public static void deleteSong(SongModel song) {
        if (song == null || song.getAudioIDAudio() == null || song.getAudioIDAudio().trim().isEmpty()) {
            System.out.println("!! (SongDAO) Error: Cancion o ID invalidos");
            return;
        }

        System.out.println("-- (SongDAO) Intentando eliminar la cancion y su audio: " + song.getAudioIDAudio());

        try {
            // eliminar el archivo de cancion mp3/wav por completo (Storage)
            String storagePath = "Songs/" + song.getAudioIDAudio() + "_" + song.getOriginalName();
            Bucket bucket = StorageClient.getInstance().bucket();
            
            Blob blob = bucket.get(storagePath);
            if (blob != null) {
                blob.delete();
                System.out.println("// (SongDAO) Archivo de audio eliminado de Storage: " + storagePath);
            } else {
                System.out.println("!! (SongDAO) El archivo físico no se encontro en Storage (posiblemente ya fue borrado antes)");
            }

            // eliminar objeto del catalogo (Firestore)
            Firestore db = FirestoreClient.getFirestore();
            db.collection("Songs").document(song.getAudioIDAudio()).delete();
            System.out.println("-- (SongDAO) Documento de cancion eliminado de BD");

        } catch (Exception e) {
            System.out.println("!! (SongDAO) Error al eliminar la cancion: " + e.getMessage());
            e.printStackTrace();
        }
    }
}