package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.UserModel;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    /*
        Servlet para asistir en la puesta de atributos del usuario de la sesion,
        con fines de cargar cosas a su registro en BD y demas cosas
    */
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        System.out.println("-- (Login) Parametros de sesion");
        
        req.setCharacterEncoding("UTF-8");
        
        String uid = req.getParameter("uid");
        String email = req.getParameter("email");
        String name = req.getParameter("name");
        
        UserModel user = new UserModel();
        user.setIDUser(uid);
        user.setNameUser(name);
        user.setEmailUser(email);

        HttpSession session = req.getSession();

        session.setAttribute("user", user);
        session.setAttribute("userLoggedIn", true);

        System.out.println("// (Login) Parametros de sesion iniciados correctamente");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}