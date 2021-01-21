/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vinhnq.tblproduct.TblProductDAO;
import vinhnq.tblproduct.TblProductDTO;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "UpdateProductServlet", urlPatterns = {"/UpdateProductServlet"})
public class UpdateProductServlet extends HttpServlet {

    private final String ERROR_PAGE = "error.jsp";
    private final String UPDATE_PAGE = "adminUpdatePage.jsp";

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
        String txtCategory = request.getParameter("txtCategory");
        String txtStatus = request.getParameter("txtStatus");
        String txtIndex = request.getParameter("txtIndex");
        String txtCategory2 = request.getParameter("txtCategory2");

        try {

            if ((txtCategory != null || txtCategory2 != null) && txtStatus != null) {
                int category = -1;
                if (txtCategory2 == null) {
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
                } else {
                    switch (txtCategory2) {
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
                }
                TblProductDAO dao = new TblProductDAO();
                int status = Integer.parseInt(txtStatus);
                int index = Integer.parseInt(txtIndex);
                int size = dao.searchForListUpdate(category, status, index);
                List<TblProductDTO> list = dao.getList();
                request.setAttribute("LIST", list);
                request.setAttribute("SIZE", size);
                url = UPDATE_PAGE;
            }

        } catch (NumberFormatException e) {
            log("Number_Update:" + e.getMessage());
        } catch (NamingException ex) {
            log("Naming_Update:" + ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_Update:" + ex.getMessage());
            request.setAttribute("MESSAGE", "Không thể update product ngay bây giờ, thử lại sau");
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
