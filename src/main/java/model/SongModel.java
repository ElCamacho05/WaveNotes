package model;

import java.io.Serializable;
import com.google.cloud.firestore.annotation.Exclude;

public class SongModel implements Serializable {
    private String audioIDAudio;
    private String originalName;
    private byte[] songBytes;
    private double durationAudio;
    private String urlAudio;

    public SongModel() {
    }
    
    public String getAudioIDAudio() {
        return audioIDAudio;
    }

    public void setAudioIDAudio(String audioIDAudio) {
        this.audioIDAudio = audioIDAudio;
    }

    public String getUrlAudio() {
        return urlAudio;
    }

    public void setUrlAudio(String urlAudio) {
        this.urlAudio = urlAudio;
    }

    public double getDurationAudio() {
        return durationAudio;
    }

    public void setDurationAudio(double durationAudio) {
        this.durationAudio = durationAudio;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    @Exclude
    public byte[] getSongBytes() {
        return songBytes;
    }

    @Exclude
    public void setSongBytes(byte[] songBytes) {
        this.songBytes = songBytes;
    }

    @Exclude
    public double getSongDuration() {
        double duration = 0.0;

        try {
            java.io.ByteArrayInputStream bais = new java.io.ByteArrayInputStream(this.songBytes);
            javax.sound.sampled.AudioFileFormat fileFormat = javax.sound.sampled.AudioSystem.getAudioFileFormat(bais);
            
            java.util.Map<?, ?> properties = fileFormat.properties();
            
            if (properties.containsKey("duration")) {
                Long microseconds = (Long) properties.get("duration");
                duration = microseconds / 1_000_000.0; // convertir de microsegundos a segundos
            } else {
                // si es un wav ya se tiene el tamaño nativo
                javax.sound.sampled.AudioFormat format = fileFormat.getFormat();
                long frames = fileFormat.getFrameLength();
                duration = (double) frames / format.getFrameRate();
            }
            
            System.out.println("-- (Song Model) Duracion calculada: " + duration + " segundos");
            
        } catch (Exception e) {
            System.out.println("!! (Song Model) Aviso: No se pudo calcular la duración del audio: " + e.getMessage());
        }
        return duration;
    }
    
}
