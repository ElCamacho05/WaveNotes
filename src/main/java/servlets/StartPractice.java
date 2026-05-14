package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.firebase.FirebaseApp;

import database.dataAccessObjects.PracticesDAO;
import model.PracticeModel;

@WebServlet("/startup")
public class StartPractice extends HttpServlet {
    /*
        Servlet para guardar los datos de inicio de la practica en la base de datos del usuario
    */
    private static final long serialVersionUID = 1;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        System.out.println("-- (Startup) Estableciendo parametros de la practica...");

        PracticeModel practice = new PracticeModel();

        practice.setTitlePractice("prueba");
        PracticesDAO.createPractice(practice);

        System.out.println("-- (Startup)practica guardada correctamente");
    }
}