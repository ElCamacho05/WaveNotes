package servlets;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import database.dataAccessObjects.PracticesDAO;
import database.dataAccessObjects.SongDAO;
import model.PracticeModel;
import model.SongModel;
import model.UserModel;

@WebServlet("/practices")
public class ManagePracticesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession session = req.getSession();
        UserModel user = (UserModel) session.getAttribute("user");
        List<PracticeModel> practices = PracticesDAO.getPractices(user.getIDUser());

        if (practices.isEmpty()){
            System.out.println("!! (PracticesServlet) No practicas para el usuario");
            resp.sendRedirect(req.getContextPath() + "/createPractice.jsp");
        }
        else {
            System.out.println("!! (PracticesServlet) Se encontraron practicas, redirigiendo a MyPractices");
            session.setAttribute("practices", practices);
            resp.sendRedirect(req.getContextPath() + "/myPractices.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        System.out.println("-- (PracticesServlet) Subiendo informacion de la practica a Firebase");

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

        SongModel track = new SongModel();
        SongModel song = new SongModel();

        track.setOriginalName(songPracticeTitleName + "_" + songInstrument + ".mp3");
        song.setOriginalName(songPracticeTitleName + "_original" + ".mp3");
        
        String jsonNotes = "[]";

        // bytes
            // extraccion de la pista de la RAM
        try {
            Map<String, byte[]> inMemTracks = (Map<String, byte[]>) session.getAttribute("generatedTracks");
            byte[] trackToUpload = inMemTracks.get(selectedInstrumentFileName);
            if (trackToUpload == null) {
                resp.sendRedirect(req.getContextPath() + "/createPractice.jsp");
                return;
            }
            track.setSongBytes(trackToUpload);
            track.setDurationAudio(track.getSongDuration());

            byte[] songToUpload = (byte[]) session.getAttribute("originalSongBytes");
            if (songToUpload == null) {
                resp.sendRedirect(req.getContextPath() + "/createPractice.jsp");
                return;
            }
            song.setSongBytes(songToUpload);
            song.setDurationAudio(song.getSongDuration());

            // extraccion de notas mediante Endpoint de python
            System.out.println("-- (PracticesServlet) Solicitando extraccion de notas a Python para: " + songInstrument);
            URI uri;
            switch (songInstrument) {
                case "drums": uri = new URI("http://127.0.0.1:8000/wn/drums"); break;
                case "bass":  uri = new URI("http://127.0.0.1:8000/wn/bass"); break;
                case "other": 
                case "guitar":uri = new URI("http://127.0.0.1:8000/wn/guitar"); break;
                default:      uri = new URI("http://127.0.0.1:8000/wn/pitch"); break;
            }

            HttpClient client = HttpClient.newBuilder().version(HttpClient.Version.HTTP_1_1).build();
            HttpRequest request = HttpRequest.newBuilder()
                .uri(uri)
                .header("Content-Type", "audio/mpeg")
                .POST(HttpRequest.BodyPublishers.ofByteArray(trackToUpload))
                .build();
                
            HttpResponse<String> pythonResponse = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (pythonResponse.statusCode() == 200) { 
                String jsonResult = pythonResponse.body();
                int startIndex = jsonResult.indexOf("[");
                int endIndex = jsonResult.lastIndexOf("]");
                
                if(startIndex != -1 && endIndex != -1) {
                    jsonNotes = jsonResult.substring(startIndex, endIndex + 1);
                    System.out.println("// (PracticesServlet) Notas extraidas correctamente");
                } else {
                    System.out.println("!! (PracticesServlet) Python no devolvio un formato de array válido");
                }
            } else {
                System.out.println("!! (PracticesServlet) Error HTTP de Python: " + pythonResponse.statusCode());
            }
        } catch (Exception e) {
            System.out.println("!! (PracticesServlet) No se encontro el audio en RAM o hubo un error al calcular el peso de la cancion");

        }
        
        try {
            track = SongDAO.uploadAndRegisterSong(track);
            song = SongDAO.uploadAndRegisterSong(song);

            if (track.getUrlAudio() == null || track.getUrlAudio().isEmpty() || song.getUrlAudio() == null || song.getUrlAudio().isEmpty()) {
                System.out.println("!! (PracticesServlet) La URL generada fue nula o vacia");
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar URLs en Storage.");
                return;
            }
        } catch (Exception e) {
            System.out.println("!! (PracticesServlet) Error al cargar practica en BD");
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
        practice.setTrack(track);
        practice.setNotesJson(jsonNotes);

        PracticesDAO.createPractice(user.getIDUser(), practice);

        System.out.println("// (PracticesServlet) Practica del usuario generada correctamente");
        
        session.removeAttribute("generatedTracks");
        session.removeAttribute("originalSongBytes");
        
        resp.sendRedirect(req.getContextPath() + "/myPractices.jsp");
    }
}
