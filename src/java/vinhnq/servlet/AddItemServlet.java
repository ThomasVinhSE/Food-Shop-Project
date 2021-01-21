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
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vinhnq.cart.CartObject;
import vinhnq.tblaccount.TblAccountDTO;
import vinhnq.tblproduct.TblProductDAO;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "AddItemServlet", urlPatterns = {"/AddItemServlet"})
public class AddItemServlet extends HttpServlet {

    private final String SEARCH_SERVLET = "SearchServlet";
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
        String id = request.getParameter("txtProductId");
        String quantity = request.getParameter("txtQuantity");
        String url = ERROR_PAGE;

        try {
            HttpSession session = request.getSession();
            CartObject cart = (CartObject) session.getAttribute("CART");
            if (cart == null) {
                cart = new CartObject();
            }
            int productId = -1;
            int amount = -1;
            productId = Integer.parseInt(id);
            amount = Integer.parseInt(quantity);

            if (productId != -1 && amount != -1) {
                if (((TblAccountDTO) session.getAttribute("ACCOUNT")).getRole() != 1) {
                    cart.addItem(productId, amount);
                    session.setAttribute("CART", cart);
                    TblProductDAO dao = new TblProductDAO();
                    dao.getListRecomment(cart.getMap());
                    request.getServletContext().setAttribute("RECOMMENT", dao.getList());
                    url = SEARCH_SERVLET;
                }
                else
                    request.setAttribute("MESSAGE", "Admin can't buy the product, thử lại với người dùng");
            }

        } catch (NumberFormatException e) {
            log("NumberFormat_AddCart: " + e.getMessage());
        } catch (NamingException ex) {
            log("Naming_AddCart: " + ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_AddCart: " + ex.getMessage());
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
