package servlets;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/separator")
@MultipartConfig
public class SongUploaderServlet extends HttpServlet{
    /*
        Servlet para el envio de la cancion del usuario a backend en python para su separacion
    */

    private static final long serialVersionUID = 1;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        InputStream audioInput = null;
        ArrayList<String> audioListOutput = null;
        
        System.out.println("-- (SongUploader) intentando separar cancion...");
        audioInput = req.getPart("audio").getInputStream();

        try {
            // lectura del .mp3
            byte[] fileBytes = audioInput.readAllBytes();
            req.getSession().setAttribute("originalSongBytes", fileBytes);
            
            System.out.println("-- (SongUploader) Enviando " + fileBytes.length + " bytes a Python...");

            HttpClient client = HttpClient.newBuilder() // uvicorn no me funcionaba con otra version
                .version(HttpClient.Version.HTTP_1_1)
                .build();
            
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("http://127.0.0.1:8000/wn/separator"))
                .header("Content-Type", "audio/mpeg")
                .POST(HttpRequest.BodyPublishers.ofByteArray(fileBytes))
                .build();
                
            HttpResponse<InputStream> response = client.send(request, HttpResponse.BodyHandlers.ofInputStream());

            if (response.statusCode() == 200) { // respuesta OK
                System.out.println("// (SongUploader) Status: 200. Intentando desempaquetar y guardar");

                ZipInputStream zis = new ZipInputStream(response.body()); // apertura del zip de respuesta (separate_in_memory)
                ZipEntry entry;
                
                // arreglo para las pistas
                Map<String, byte[]> inMemTracks = new HashMap<>();

                while ((entry = zis.getNextEntry()) != null) {
                    String nombrePista = entry.getName();
                    
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = zis.read(buffer)) > 0) {
                        baos.write(buffer, 0, len);
                    }
                    
                    // guardado de las pistas en arreglo (arreglo buffer de bytes)
                    inMemTracks.put(nombrePista, baos.toByteArray());
                    zis.closeEntry();
                }
                zis.close();

                // Guardado de pistas para la sesion de usuario
                req.getSession().setAttribute("generatedTracks", inMemTracks);
                System.out.println("// (SongUploader) Pistas listas para reproduccion.");
                req.getSession().setAttribute("processedAudio", audioListOutput);
                resp.sendRedirect(req.getContextPath() + "/createPractice.jsp");
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (audioInput != null) {
                audioInput.close(); // Buena práctica para liberar memoria
            }
        }

        
    }
}
