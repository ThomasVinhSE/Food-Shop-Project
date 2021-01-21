/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;
import org.json.JSONTokener;
import vinhnq.tblaccount.TblAccountDAO;
import vinhnq.tblaccount.TblAccountDTO;
import vinhnq.utilities.GoogleUtil;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private final String INVALID_PAGE = "invalid.html";
    private final String WELCOME_PAGE = "welcome.jsp";
    private final String ERROR_PAGE = "error.jsp";

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String googleCode = request.getParameter("code");

        String username = request.getParameter("txtUsername");
        String password = request.getParameter("txtPassword");
        TblAccountDAO dao = new TblAccountDAO();
       
        String state = request.getParameter("state");
        
        String url = ERROR_PAGE;
        String email = "";
        try {
            TblAccountDTO dto = null;
            if (googleCode != null) {
                email = GoogleUtil.getInfoOfUser(googleCode);
                dto = dao.checkLoginGoogle(email);
            } else {
                dto = dao.checkLogin(username, password);
            }
            if (dto != null) {
                HttpSession session = request.getSession();
                session.setAttribute("ACCOUNT", dto);
                Cookie cookie = null;
                if (googleCode != null) {
                    cookie = new Cookie("google", email);
                } else {
                    cookie = new Cookie(username, password);
                }
                response.addCookie(cookie);
                url = WELCOME_PAGE;
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                request.setAttribute("MESSAGE", "Tài khoản không tồn tại... or xảy ra lỗi. Vui lòng thử lại");
            }
        } catch (NamingException e) {
            log("Naming_Login: " + e.getMessage());
        } catch (SQLException e) {
            log("SQL_Login: " + e.getMessage());
        } catch (Exception ex) {
            log("Exception_Login: " + ex.getMessage());
            if (ex.getMessage().contains("400")) {
                request.setAttribute("MESSAGE", "Chưa đăng nhập, vui lòng thử lại bằng tài khoản khác!");
            }
        } finally {
            if (state == null) {
                RequestDispatcher rd = request.getRequestDispatcher(url);
                rd.forward(request, response);
            } else {
                JSONTokener tokener = new JSONTokener(state);
                JSONObject json = new JSONObject(tokener);
                String txtProductId = json.getString("txtProductId");
                String txtQuantity = json.getString("txtQuantity");
                url = "DispatcherServlet?";
                Set<String> keys = json.keySet();
                for (String key : keys) {
                    String value = json.getString(key);
                    url += "&"+key+"="+value;
                }
                response.sendRedirect(url);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
