package model;
import java.io.Serializable;

public class NoteModel implements Serializable {
    private String pitch;
    private int timeFrame;

    public NoteModel() {
    }

    public String getPitch() {
        return pitch;
    }

    public void setPitch(String pitch) {
        this.pitch = pitch;
    }

    public int getTimeFrame() {
        return timeFrame;
    }

    public void setTimeFrame(int timeFrame) {
        this.timeFrame = timeFrame;
    }

    
    
}