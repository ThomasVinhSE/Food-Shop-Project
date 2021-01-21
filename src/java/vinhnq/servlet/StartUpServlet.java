/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.sql.SQLException;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vinhnq.tblaccount.TblAccountDAO;
import vinhnq.tblaccount.TblAccountDTO;

/**
 *
 * @author Vinh
 */
public class StartUpServlet extends HttpServlet {

    private final String HOME_PAGE = "home.jsp";
    private final String WELCOME_PAGE = "welcome.jsp";
    private final String ERROR_PAGE = "error.jsp";
    private final String ADMIN_PAGE = "adminPage.jsp";

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
        request.setCharacterEncoding("UTF-8");
        String url = HOME_PAGE;
        try {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("ACCOUNT") != null) {
                Cookie[] cookies = request.getCookies();
//                for (Cookie cooky : cookies) {
//                    System.out.println(cooky.getName()+"-"+cooky.getValue());
//                }
                if (cookies != null) {
                    Cookie cookie = cookies[cookies.length - 1];
                    if (cookie.getName().equals("JSESSIONID")) {
                        if (cookies.length >= 2) {
                            cookie = cookies[cookies.length - 2];
                        } else {
                            cookie = null;
                        }
                    }
                    if (cookie != null) {
                        String username = cookie.getName();
                        String password = cookie.getValue();
                        TblAccountDAO dao = new TblAccountDAO();
                        TblAccountDTO dto = null;
                        if(username.equals("google"))
                            dto = dao.checkLoginGoogle(password);
                        else
                            dto = dao.checkLogin(username, password);
                        if (dto != null) {
                            session.setAttribute("ACCOUNT", dto);
                            if(dto.getRole() != 1)
                                url = WELCOME_PAGE;
                            else
                                url = ADMIN_PAGE;
                        } else {
                            session.invalidate();
                        }
                    }
                }
            }
        } catch (NamingException ex) {
            log("Naming_Start: " + ex.getMessage());
            url = ERROR_PAGE;
        } catch (SQLException ex) {
            log("SQL_Start: " + ex.getMessage());
            url = ERROR_PAGE;
        } finally {
            RequestDispatcher rd = request.getRequestDispatcher(url);
            rd.forward(request, response);
            
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
