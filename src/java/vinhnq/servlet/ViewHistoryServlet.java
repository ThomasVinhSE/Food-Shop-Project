/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vinhnq.tblaccount.TblAccountDTO;
import vinhnq.tblorder.TblOrderDAO;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "ViewHistoryServlet", urlPatterns = {"/ViewHistoryServlet"})
public class ViewHistoryServlet extends HttpServlet {

    private final String VIEW_PAGE = "viewHistory.jsp";
    private final String ERROR_PAGE = "error.jsp";
    private final String DETAIL_PAGE = "detailHistory.jsp";

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
        String txtBillName = request.getParameter("txtBillName");
        String txtDate = request.getParameter("txtDate");
        String url = ERROR_PAGE;
        String isDetail = request.getParameter("isDetail");

        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                TblOrderDAO dao = new TblOrderDAO();
                if (txtBillName == null) {
                    txtBillName = "";
                }
                if (txtDate == null) {
                    txtDate = "";
                }
                if (isDetail == null) {
                    TblAccountDTO dto = (TblAccountDTO) session.getAttribute("ACCOUNT");
                    Integer userID = dto.getId();
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    Date date = null;
                    if(txtDate != null && !txtDate.equals(""))
                        date = format.parse(txtDate);
                    dao.getOrderHistory(dto.getId(), txtBillName, date);
                    request.setAttribute("HISTORY", dao.getList());
                    url = VIEW_PAGE;
                } else {
                    String orderId = request.getParameter("txtOrderId");
                    Integer orId = Integer.parseInt(orderId);
                    dao.getFinalDetailMap(orId);
                    request.setAttribute("DETAIL", dao.getDetailMap());
                    url = DETAIL_PAGE;
                }

            }
        } catch (NumberFormatException e) {
            log("Number_History: " + e.getMessage());
        } catch (NamingException ex) {
            log("Naming_History: " + ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_History: " + ex.getMessage());
        } catch (ParseException ex) {
            log("ParseException_ViewHistory: "+ex.getMessage());
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
