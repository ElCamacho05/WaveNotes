package servlets;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/notes")
public class NotesServlet extends HttpServlet {
    /*
        Servlet para el envio de la pista (track) separada seleccionada por el usuario a backend en python para la obtencion de array de notas musicales
    */
    private static final long serialVersionUID = 1;
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // Cancion elegida
        String trackName = req.getParameter("selectedSong");
        
        // Recuperacion de las pistas enviadas como atributos anteriormente
        Map<String, byte[]> inMemTracks = (Map<String, byte[]>) req.getSession().getAttribute("generatedTracks");

        if (inMemTracks != null && inMemTracks.containsKey(trackName)) {
            
            // obtencion de los bytes de la pista seleccionada
            byte[] audioToProcess = inMemTracks.get(trackName);
            
            System.out.println("-- (Notes) Pista seleccionada: " + trackName);
            System.out.println("-- (Notes) Enviando " + audioToProcess.length + " bytes a Python...");

            try {
                // String[] separated = trackName.split("\\.");
                // System.out.println(separated.length);
                // for (int i = 0; i< separated.length; i++)
                // {
                //     System.out.println(separated[i]);
                // }
                String track = trackName.split("\\.")[0];
                URI uri;
                
                switch (track) {
                    case "drums":
                        uri = new URI("http://127.0.0.1:8000/wn/drums");
                        break;
                    case "bass":
                        uri = new URI("http://127.0.0.1:8000/wn/bass");
                        break;
                    case "vocals":
                        uri = new URI("http://127.0.0.1:8000/wn/pitch");
                        break;
                    case "other":
                        uri = new URI("http://127.0.0.1:8000/wn/guitar");
                        break;
                    default:
                        uri = new URI("http://127.0.0.1:8000/wn/pitch");
                }


                HttpClient client = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_1_1)
                    .build();
                
                HttpRequest request = HttpRequest.newBuilder()
                    .uri(uri)
                    .header("Content-Type", "audio/mpeg")
                    .POST(HttpRequest.BodyPublishers.ofByteArray(audioToProcess))
                    .build();
                    
                // Recepcion como JSON
                HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
                
                if (response.statusCode() == 200) { // Respuesta OK
                    String jsonResult = response.body();
                    System.out.println("-- (Notes) Respuesta de Python: " + jsonResult);
                    
                    // extraccion en corto del arreglo
                    int startIndex = jsonResult.indexOf("[");
                    int endIndex = jsonResult.lastIndexOf("]");
                    
                    if(startIndex != -1 && endIndex != -1) {
                        String notes = jsonResult.substring(startIndex, endIndex + 1);
                        req.getSession().setAttribute("pitches", notes);
                    } else {
                        req.getSession().setAttribute("pitches", "No se encontraron notas validas");
                    }
                } else {
                    System.out.println("-- (Notes) No OK, Error: " + response.statusCode());
                }
                
            } catch (Exception e) {
                System.out.println("-- (Notes) Error en envio: " + e.getMessage());
                e.printStackTrace();
            }

        } else {
            System.out.println("-- (Notes) Error: Pista no encontrada en la memoria.");
        }
        
        // Redireccion al origen para recargar la pagina con las notas
        System.out.println("-- (Notes) Regresando informacion obtenida (o no...)");

        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}