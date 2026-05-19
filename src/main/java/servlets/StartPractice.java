package servlets;

import java.io.IOException;
import java.util.Date;
import java.util.Map;

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

@WebServlet("/startup")
public class StartPractice extends HttpServlet {
    private static final long serialVersionUID = 1;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        System.out.println("-- (Startup) Subiendo informacion de la practica a Firebase");

        req.setCharacterEncoding("UTF-8"); 
        
        HttpSession session = req.getSession();
        String uid = (String) session.getAttribute("uid");
        
        if (uid == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Usuario no autenticado");
            return;
        }

        String selectedInstrumentFile = req.getParameter("selectedSong");
        String titlePractice = req.getParameter("titlePractice");
        
        String instrumentName = selectedInstrumentFile.replace(".mp3", ""); 

        // extraccion de la pista de la RAM
        Map<String, byte[]> inMemTracks = (Map<String, byte[]>) session.getAttribute("generatedTracks");
        byte[] audioToUpload = inMemTracks.get(selectedInstrumentFile);

        if (audioToUpload == null) {
            System.out.println("!! (Startup) No se encontro el audio en RAM.");
            resp.sendRedirect(req.getContextPath() + "/createPractice.jsp");
            return;
        }

        String realSongId = "";
        try {
            connection.getFirebaseConnection();
            // carga a Firebase de la cancion
            System.out.println("-- (Startup) Subiendo " + audioToUpload.length + " bytes a Firebase Storage...");

            // TODO. cambiar la duracion del audio
            realSongId = SongDAO.uploadAndRegisterSong(audioToUpload, titlePractice + "_" + selectedInstrumentFile, 0.0);
            
            System.out.println("// (Startup) Audio subido a Storage exitosamente. ID del audio: " + realSongId);
        } catch (Exception e) {
            System.out.println("!! (Startup) Error al subir a Storage: " + e.getMessage());
            e.printStackTrace();
            return;
        }

        // Construccion de registro de Practica de usuario
        PracticeModel practice = new PracticeModel();
        practice.setInstrumentPractice(instrumentName);
        practice.setTitlePractice(titlePractice);
        practice.setCreationPractice(new Date());
        practice.setScorePractice(0);
        practice.setAccuracyPractice(0);

        PracticesDAO.createPractice(uid, practice, realSongId);

        System.out.println("-- (Startup) Practica del usuario generada correctamente");
        
        session.removeAttribute("generatedTracks"); // eliminacion de pistas temporales
        
        resp.sendRedirect(req.getContextPath() + "/myPractices.jsp");
    }
}