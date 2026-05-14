package model;

import java.util.Date;
import java.util.List;
import org.javatuples.Pair;

public class PracticeModel {
    // Owner
    private UserModel userPractice;

    // Atributos propios
    private String titlePractice;
    private Date creationPractice;
    private int scorePractice;
    private int accuracyPractice;

    // Audio
    private AudioModel audio;

    // Track seleccionado
    private String instrumentPractice;

    // Notas generadas
    List<Pair <String, Integer>> notesPractice;

    public UserModel getUserPractice() {
        return userPractice;
    }

    public void setUserPractice(UserModel userPractice) {
        this.userPractice = userPractice;
    }

    public String getTitlePractice() {
        return titlePractice;
    }

    public void setTitlePractice(String titlePractice) {
        this.titlePractice = titlePractice;
    }

    public Date getCreationPractice() {
        return creationPractice;
    }

    public void setCreationPractice(Date creationPractice) {
        this.creationPractice = creationPractice;
    }

    public int getScorePractice() {
        return scorePractice;
    }

    public void setScorePractice(int scorePractice) {
        this.scorePractice = scorePractice;
    }

    public int getAccuracyPractice() {
        return accuracyPractice;
    }

    public void setAccuracyPractice(int accuracyPractice) {
        this.accuracyPractice = accuracyPractice;
    }

    public AudioModel getAudio() {
        return audio;
    }

    public void setAudio(AudioModel audio) {
        this.audio = audio;
    }

    public String getInstrumentPractice() {
        return instrumentPractice;
    }

    public void setInstrumentPractice(String instrumentPractice) {
        this.instrumentPractice = instrumentPractice;
    }

    public List<Pair<String, Integer>> getNotesPractice() {
        return notesPractice;
    }

    public void setNotesPractice(List<Pair<String, Integer>> notesPractice) {
        this.notesPractice = notesPractice;
    }

    
}