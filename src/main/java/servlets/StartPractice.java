package servlets;

import java.io.IOException;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import database.connections.connection;
import database.dataAccessObjects.PracticesDAO;
import database.dataAccessObjects.SongDAO;
import model.PracticeModel;
import model.SongModel;
import model.UserModel;

@WebServlet("/startup")
public class StartPractice extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        System.out.println("-- (Startup) Subiendo informacion de la practica a Firebase");

        req.setCharacterEncoding("UTF-8"); 
        
        HttpSession session = req.getSession();
        UserModel user = (UserModel) session.getAttribute("user");
        
        if (user == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Usuario no autenticado");
            return;
        }

        String selectedInstrumentFileName = req.getParameter("selectedSong");
        String songInstrument = selectedInstrumentFileName.replace(".mp3", "");
        String songPracticeTitleName = req.getParameter("titlePractice");
        
        // Song

        SongModel song = new SongModel();

        song.setOriginalName(songPracticeTitleName + songInstrument + ".mp3");
            // bytes
            // extraccion de la pista de la RAM
        try {
            Map<String, byte[]> inMemTracks = (Map<String, byte[]>) session.getAttribute("generatedTracks");
            byte[] audioToUpload = inMemTracks.get(selectedInstrumentFileName);
            if (audioToUpload == null) {
                resp.sendRedirect(req.getContextPath() + "/createPractice.jsp");
                return;
            }
            song.setSongBytes(audioToUpload);
            song.setDurationAudio(song.getSongDuration());
        } catch (Exception e) {
            System.out.println("!! (Startup) No se encontro el audio en RAM o hubo un error al calcular el peso de la cancion");

        }
        
        try {
            song = SongDAO.uploadAndRegisterSong(song);
            if (song.getUrlAudio() == null || song.getUrlAudio().isEmpty()) {
                System.out.println("!! (Startup) La URL generada fue nula o vacia");
                return;
            }
        } catch (Exception e) {
            System.out.println("!! (Startup) Error al cargar practica en BD");
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al subir archivos.");
            e.printStackTrace();
        }
        
        PracticeModel practice = new PracticeModel();
        practice.setTrackInstrumentPractice(songInstrument);
        practice.setTitlePractice(songPracticeTitleName);
        practice.setDatePractice(new Date());
        practice.setScorePractice(0);
        practice.setAccuracyPractice(0);
        practice.setSong(song);

        PracticesDAO.createPractice(user.getIDUser(), practice);

        System.out.println("-- (Startup) Practica del usuario generada correctamente");
        
        session.removeAttribute("generatedTracks"); // eliminacion de pistas temporales
        
        resp.sendRedirect(req.getContextPath() + "/myPractices.jsp");
    }
}