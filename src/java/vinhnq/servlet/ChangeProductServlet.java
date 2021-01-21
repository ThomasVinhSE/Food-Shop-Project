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
import vinhnq.tblaccount.TblAccountDTO;
import vinhnq.tblhistory.TblHistoryDAO;
import vinhnq.tblproduct.TblProductDAO;
import vinhnq.tblproduct.TblProductDTO;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "ChangeProductServlet", urlPatterns = {"/ChangeProductServlet"})
public class ChangeProductServlet extends HttpServlet {

    private final String ERROR_PAGE = "error.jsp";
    private final String UPDATE_SERVLET = "UpdateProductServlet";

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
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                TblProductDTO dto = (TblProductDTO) request.getAttribute("DTO");
                if (dto != null) {
                    TblProductDAO dao = new TblProductDAO();
                    int category = Integer.parseInt(request.getParameter("txtCategory"));
                    dto.setCategoryId(category);
                    boolean result = dao.updateProduct(dto);
                    if (result) {
                        Integer accountId = ((TblAccountDTO) session.getAttribute("ACCOUNT")).getId();
                        TblHistoryDAO historyDAO = new TblHistoryDAO();
                        String message = "Cập nhật "+dto.toString();
                        result = historyDAO.backupAction(accountId, message);
                        if(result)
                            url = UPDATE_SERVLET;
                    }
                }
            }

        } catch (NumberFormatException ex) {
            log("Number_Change: " + ex.getMessage());
        } catch (NamingException ex) {
            log("Naming_Change: " + ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_Change: " + ex.getMessage());
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
