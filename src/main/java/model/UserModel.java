package model;

import java.io.Serializable;
import java.util.List;

public class UserModel implements Serializable{
    private String IDUser;
    private String emailUser;
    private String nameUser;
    private List<PracticeModel> Practices;
    
    public UserModel() {
    }

    public String getIDUser() {
        return IDUser;
    }

    public void setIDUser(String iDUser) {
        IDUser = iDUser;
    }

    public String getEmailUser() {
        return emailUser;
    }

    public void setEmailUser(String emailUser) {
        this.emailUser = emailUser;
    }

    public String getNameUser() {
        return nameUser;
    }

    public void setNameUser(String nameUser) {
        this.nameUser = nameUser;
    }

    public List<PracticeModel> getPractices() {
        return Practices;
    }

    public void setPractices(List<PracticeModel> practices) {
        Practices = practices;
    }
}
