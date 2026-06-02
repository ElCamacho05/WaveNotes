package servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import database.dataAccessObjects.PracticesDAO;
import model.PracticeModel;
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
}
