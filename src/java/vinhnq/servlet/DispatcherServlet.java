/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Vinh
 */
@javax.servlet.annotation.MultipartConfig
public class DispatcherServlet extends HttpServlet {
    
    private final String HOME_PAGE = "home.jsp";
    private final String ADMIN_PAGE = "adminPage.jsp";
    
    private final String LOGIN_SERVLET = "LoginServlet";
    private final String LOGOUT_SERVLET = "LogoutServlet";
    private final String STARTUP_SERVLET = "StartUpServlet";
    private final String SEARCH_SERVLET = "SearchServlet";
    private final String ADD_TO_CART = "AddItemServlet";
    private final String REMOVE_OUT_CART = "RemoveOutCartServlet";
    private final String VIEW_CART_SERVLET = "ViewCartServlet";
    private final String CHECK_OUT_SERVLET = "CheckOutServlet";
    private final String VIEW_HISTORY_SERVLET = "ViewHistoryServlet";
    private final String UPDATE_CART_SERVLET = "UpdateCartServlet";
    private final String AJAX_PRODUCT_SERVLET = "AJAXProductServlet";
    private final String CREATE_PRODUCT_SERVLET = "CreateProductServlet";
    private final String UPDATE_PRODUCT_SERVLET = "UpdateProductServlet";
    private final String DELETE_PRODUCT_SERVLET =  "DeleteProductServlet";
    private final String RESTORE_PRODUCT_SERVLET = "RestoreProductServlet";
    private final String CHANGE_PRODUCT_SERVLET = "ChangeProductServlet";
    private final String PAYMENT_SERVLET = "PaymentServlet";
    
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String button = request.getParameter("btnAction");
        String url = HOME_PAGE;
        PrintWriter out = response.getWriter();
        try {
            if(button == null)
            {
                url = STARTUP_SERVLET;
            }
            else if("Admin".equals(button))
            {
                url = ADMIN_PAGE;
            }
            else  if("Login".equals(button))
            {
                url = LOGIN_SERVLET;
            }
            else if("Logout".equals(button))
            {
                url = LOGOUT_SERVLET;
            }
            else if("Search".equals(button))
            {
                url = SEARCH_SERVLET;
            }
            else if("AddToCart".equals(button))
            {
                url = ADD_TO_CART;
            }
            else if("Cart".equals(button))
            {
                url = VIEW_CART_SERVLET;
            }
            else if("Remove".equals(button))
            {
                url = REMOVE_OUT_CART;
            }
            else if("Payment".equals(button))
            {
                url = PAYMENT_SERVLET;
            }
            else if("Checkout".equals(button))
            {
                url = CHECK_OUT_SERVLET;
            }
            else if("History".equals(button))
            {
                url = VIEW_HISTORY_SERVLET;
            }
            else if("UpdateCart".equals(button))
            {
                url = UPDATE_CART_SERVLET;
            }
            else if("GetProduct".equals(button))
            {
                url = AJAX_PRODUCT_SERVLET;
            }
            else if("Create".equals(button))
            {
                url = CREATE_PRODUCT_SERVLET;
            }
            else if("Update".equals(button))
            {
                url = UPDATE_PRODUCT_SERVLET;
            }
            else if("Delete".equals(button))
            {
                url = DELETE_PRODUCT_SERVLET;
            }
            else if("Restore".equals(button))
            {
                url = RESTORE_PRODUCT_SERVLET;
            }
            else if("Change".equals(button))
            {
                url = CHANGE_PRODUCT_SERVLET;
            }
        }
        finally{
            
            RequestDispatcher rd = request.getRequestDispatcher(url);
            rd.forward(request, response);
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
