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

/**
 *
 * @author Vinh
 */
@WebServlet(name = "UpdateCartServlet", urlPatterns = {"/UpdateCartServlet"})
public class UpdateCartServlet extends HttpServlet {

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
        String txtProductId = request.getParameter("txtProductId");
        String txtAmount = request.getParameter("txtAmount");
        String txtNumber = request.getParameter("txtNumber");
        try {
            int amount;
            int number;
            int id;
            amount = txtAmount == null || txtAmount.equals("") ? -1 : Integer.parseInt(txtAmount);
            number = txtNumber == null || txtAmount.equals("") ? -1 : Integer.parseInt(txtNumber);
            id = txtProductId == null || txtProductId.equals("") ? -1 : Integer.parseInt(txtProductId);
            if (amount <= 0 || number <= 0) {
                throw new Exception("Not < 0 for updating!");
            } else {

                HttpSession session = request.getSession(false);
                if (session != null) {
                    CartObject cart = (CartObject) session.getAttribute("CART");
                    if (cart != null) {
                        Map<Integer, Integer> items = cart.getMap();
                        if (items != null) {
                            if (items.containsKey(id)) {
                                items.put(id, number);
                                session.setAttribute("CART", cart);
                                url = VIEW_CART_SERVLET;
                            }
                        }
                    }
                }
            }

        } catch (SQLException e) {
            log("SQL_UpdateServlet: " + e.getMessage());
        } catch (NamingException e) {
            log("Naming_UpdateServlet: " + e.getMessage());
        } catch (NumberFormatException e) {
            log("NumberFormat_UpdateServlet: " + e.getMessage());
        } catch (Exception ex) {
            log("Input param_UpdateServlet: " + ex.getMessage());
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
