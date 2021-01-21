/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vinhnq.cart.CartObject;
import vinhnq.tblproduct.TblProductDAO;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "RemoveOutCartServlet", urlPatterns = {"/RemoveOutCartServlet"})
public class RemoveOutCartServlet extends HttpServlet {

    private final String ERROR_PAGE = "error.jsp";

    private final String VIEW_CART_SERVLET = "ViewCartServlet";

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
        String url = ERROR_PAGE;
        String productId = request.getParameter("txtProductId");
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                CartObject cart = (CartObject) session.getAttribute("CART");
                if (cart != null) {
                    int id = -1;
                    id = Integer.parseInt(productId);
                    if (id != -1) {

                        cart.removeItem(id);
                        Map<Integer, Integer> map = cart.getMap();
                        if (map != null) {
                            TblProductDAO dao = new TblProductDAO();
                            dao.getListRecomment(map);
                            request.getServletContext().setAttribute("RECOMMENT", dao.getList());
                        }
                        session.setAttribute("CART", cart);
                        url = VIEW_CART_SERVLET;
                    };
                };
            };
        } catch (NumberFormatException e) {
            log("NumberFormat_Remove: " + e.getMessage());
        } catch (NamingException ex) {
            log("Naming_Remove: "+ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_Remove: "+ex.getMessage());
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
