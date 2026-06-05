package model;

import java.io.Serializable;
import java.util.Date;

public class PracticeModel implements Serializable{
    // Atributos propios
    private String IDPractice;
    private String titlePractice;
    private Date datePractice;
    private int scorePractice;
    private int accuracyPractice;

    // Audio
    private SongModel song;
    private SongModel track;

    // Track seleccionado
    private String trackInstrumentPractice;

    // Notas generadas
    private String notesJson;

    public PracticeModel() {
    }

    public String getTitlePractice() {
        return titlePractice;
    }

    public void setTitlePractice(String titlePractice) {
        this.titlePractice = titlePractice;
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

    public Date getDatePractice() {
        return datePractice;
    }

    public void setDatePractice(Date datePractice) {
        this.datePractice = datePractice;
    }

    public SongModel getSong() {
        return song;
    }

    public void setSong(SongModel song) {
        this.song = song;
    }

    public SongModel getTrack() {
        return track;
    }

    public void setTrack(SongModel track) {
        this.track = track;
    }

    public String getTrackInstrumentPractice() {
        return trackInstrumentPractice;
    }

    public void setTrackInstrumentPractice(String trackInstrumentPractice) {
        this.trackInstrumentPractice = trackInstrumentPractice;
    }

    public String getNotesJson() {
        return notesJson;
    }

    public void setNotesJson(String notesJson) {
        this.notesJson = notesJson;
    }

    public String getIDPractice() {
        return IDPractice;
    }

    public void setIDPractice(String iDPractice) {
        IDPractice = iDPractice;
    }

    @Override
    public String toString() {
        return "PracticeModel [IDPractice=" + IDPractice + ", titlePractice=" + titlePractice + ", song=" + song
                + ", trackInstrumentPractice=" + trackInstrumentPractice + "]";
    }

    

    
}