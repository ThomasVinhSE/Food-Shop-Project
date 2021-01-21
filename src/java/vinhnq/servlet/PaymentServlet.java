/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vinhnq.utilities.PayPalUtil;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        String isSubmit = request.getParameter("isSubmit");
        
        HttpSession session = request.getSession(false);
        try {
            if (isSubmit == null) {
                if (session != null) {
                    PayPalUtil paypalUtil = new PayPalUtil();
                    String accessToken = paypalUtil.getAccessToken();
                    double price = (Double) session.getAttribute("TOTAL");
                    float total = (float) price;
                    String payId = paypalUtil.getPaymentId(accessToken, total);
                    if (payId != null) {
                        out = response.getWriter();
                        out.write("{\"id\":\"" + payId + "\"}");
                    }
                }
            }
            else
            {
                String paymentID = request.getParameter("paymentID");
                String payerID = request.getParameter("payerID");
                if(session != null)
                {
                    double price = (Double) session.getAttribute("TOTAL");
                    float total = (float) price;
                    PayPalUtil paypalUtil = new PayPalUtil();
                    String accessToken = paypalUtil.getAccessToken();
                    String status = paypalUtil.executePayment(accessToken,paymentID, payerID, total);
                    if(status.equals("approved"))
                    {
                        System.out.println("Yes");
                    }
                }
            }
        } catch (Exception ex) {
            log("Exception_Payment: " + ex.getMessage());
        } finally {
            out.close();
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
