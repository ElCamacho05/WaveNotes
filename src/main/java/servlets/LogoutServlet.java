package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    /*
        Servlet para cerrar la sesion y eliminar las variables de sesion del servidor de tomcat
    */
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("-- (Logout) Destruyendo sesion en Tomcat");
        
        HttpSession session = req.getSession(false);
        
        if (session != null) {
            session.removeAttribute("user");
            session.invalidate();
        }
        
        System.out.println("// (Logout) Sesion de en Tomcat destruida. Sesion terminada");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}