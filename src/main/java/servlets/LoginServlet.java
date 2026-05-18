package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    /*
        Servlet para asistir en la puesta de atributos del usuario de la sesion,
        con fines de cargar cosas a su registro en BD y demas cosas
    */
    private static final long serialVersionUID = 1;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        System.out.println("-- (Login) Parametros de sesion");
        
        req.setCharacterEncoding("UTF-8");
        
        String uid = req.getParameter("uid");
        String email = req.getParameter("email");
        String name = req.getParameter("name");
        
        HttpSession session = req.getSession();

        session.setAttribute("userLoggedIn", true);
        session.setAttribute("uid", uid); 
        session.setAttribute("userName", name);
        session.setAttribute("userEmail", email);

        System.out.println("// (Login) Parametros de sesion iniciados correctamente");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}