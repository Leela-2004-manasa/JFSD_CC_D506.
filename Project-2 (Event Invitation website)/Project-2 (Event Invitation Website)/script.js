import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/rsvp")
public class RSVPServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        int guests = Integer.parseInt(request.getParameter("guests"));

        out.println("<html><body>");
        out.println("<h2>Thank you, " + name + "!</h2>");
        out.println("<p>We have received your RSVP for " + guests + " guests.</p>");
        out.println("<p>A confirmation email has been sent to " + email + ".</p>");
        out.println("</body></html>");
    }
}