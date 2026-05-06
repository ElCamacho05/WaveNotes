package servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/stream")
public class AudioStreamServlet extends HttpServlet {
    /*
    Servlet para la recuperacion/desempaquetado de las pistas generadas por SongUploaderServlet
     */
    private static final long serialVersionUID = 1;
            
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Obtencion del track seleccionado por el usuario
        String trackName = req.getParameter("track");
        
        // Recuperacion de las pistas generadas anteriormente
        Map<String, byte[]> tracks = (Map<String, byte[]>) req.getSession().getAttribute("pistasGeneradas");

        if (tracks != null && tracks.containsKey(trackName)) {
            byte[] audioData = tracks.get(trackName);
            
            resp.setContentType("audio/wav");
            resp.setContentLength(audioData.length);
            
            OutputStream os = resp.getOutputStream();
            os.write(audioData);
            os.flush();
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Pista no encontrada en la memoria.");
        }
    }
}