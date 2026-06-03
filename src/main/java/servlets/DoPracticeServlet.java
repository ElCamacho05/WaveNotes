package servlets;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.PracticeModel;

@SuppressWarnings("unchecked")
@WebServlet("/training")
public class DoPracticeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String IDPractice = (String) req.getParameter("IDPractice");
        System.out.println("-- (Training) Buscando practica con el indice " + IDPractice);
        
        HttpSession session = req.getSession();

        List<PracticeModel> practices = (List<PracticeModel>) session.getAttribute("practices");
        Optional<PracticeModel> actualPractice = practices.stream()
            .filter(p->IDPractice.
                equals(p.getIDPractice()))
            .findFirst();
        
        if (actualPractice.isPresent()) {
            req.setAttribute("actualPractice", actualPractice.get());
            System.out.println("// (Training) Practica encontrada con exito " + actualPractice);
            req.getRequestDispatcher("/practice.jsp").forward(req, resp);
        }
        else {
            System.out.println("!! (Training) Practica no encontrada... Redirigiendo" + actualPractice);
            resp.sendRedirect(req.getContextPath() + "/myPractices.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        
    }
}
