/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
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
import vinhnq.tblaccount.TblAccountDTO;
import vinhnq.tblproduct.TblProductDAO;
import vinhnq.tblproduct.TblProductDTO;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/SearchServlet"})
public class SearchServlet extends HttpServlet {

    private final String SEARCH_PAGE = "search.jsp";
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
        String txtSearchValue = request.getParameter("txtSearchValue");
        String txtCategory = request.getParameter("txtCategory");
        String txtMinPrice = request.getParameter("txtMinPrice");
        String txtMaxPrice = request.getParameter("txtMaxPrice");
        String txtIndex = request.getParameter("txtIndex");
        String url = SEARCH_PAGE;
        try {
            TblProductDAO dao = new TblProductDAO();
            int category = -1;
            switch (txtCategory) {
                case "All": {
                    category = 0;
                    break;
                }
                case "Food": {
                    category = 1;
                    break;
                }
                case "Drink": {
                    category = 2;
                    break;
                }
                case "Vegetable": {
                    category = 3;
                    break;
                }
                default: {
                    category = 0;
                    break;
                }
            }
            float min = 0;
            float max = 0;
            int index = 1;
            try {
                min = txtMinPrice.equals("") ? 0 : Float.parseFloat(txtMinPrice);
                max = txtMaxPrice.equals("") ? 0 : Float.parseFloat(txtMaxPrice);
                index = txtIndex.equals("") ? 1 : Integer.parseInt(txtIndex);
            } catch (NumberFormatException e) {
                log("NumberFormat_Search: " + e.getMessage());
                url = ERROR_PAGE;
            }
            Map<Integer, Integer> map = null;
            HttpSession session = request.getSession(false);
            if (session != null) {
                CartObject cart = (CartObject) session.getAttribute("CART");
                if (cart != null) {
                    map = cart.getMap();
                }
            }
            int size = dao.search2(txtSearchValue, category, min, max, index, map);
            List<TblProductDTO> list = dao.getList();
            request.setAttribute("LIST", list);
            request.setAttribute("SIZE", size);

            if (request.getServletContext().getAttribute("RECOMMENT") == null) {
                dao.setList(null);
                dao.getListRecomment(map);
                request.getServletContext().setAttribute("RECOMMENT", dao.getList());
            }
            if (session != null) {
                TblAccountDTO dto = (TblAccountDTO) session.getAttribute("ACCOUNT");
                if (dto != null) {
                    dao.setList(null);
                    dao.getListRecomment2(dto.getId(),map);
                    request.setAttribute("RECOMMENT2", dao.getList());
                }
            }

        } catch (SQLException ex) {
            log("SQL_Search: " + ex.getMessage());
            url = ERROR_PAGE;
        } catch (NamingException ex) {
            log("Naming_Search: " + ex.getMessage());
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
