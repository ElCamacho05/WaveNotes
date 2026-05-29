package model;

import java.io.Serializable;

public class AudioModel implements Serializable {
    private String audioIDAudio;
    private String urlAudio;
    private double lenghtAudio;
    private String originalName;

    public AudioModel() {
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

    public double getLenghtAudio() {
        return lenghtAudio;
    }

    public void setLenghtAudio(double lenghtAudio) {
        this.lenghtAudio = lenghtAudio;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    
}
