/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
import vinhnq.tblorder.TblOrderDAO;
import vinhnq.tblorder.TblOrderDTO;
import vinhnq.tblorderproduct.TblOrderProductDAO;
import vinhnq.tblproduct.TblProductDAO;
import vinhnq.tblproduct.TblProductDTO;
import vinhnq.utilities.Helpers;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "CheckOutServlet", urlPatterns = {"/CheckOutServlet"})
public class CheckOutServlet extends HttpServlet {

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
        Enumeration<String> enums = request.getParameterNames();

        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                CartObject cart = (CartObject) session.getAttribute("CART");
                if (cart != null) {
                    Map<Integer, Integer> items = cart.getMap();
                    if (items != null) {

                        Set<Integer> keys = items.keySet();
                        Connection cn = Helpers.makeConnection();
                        if (cn != null) {
                            cn.setAutoCommit(false);

                            TblProductDAO productDAO = new TblProductDAO();
                            List<Integer> errorList = productDAO.checkOutCart(cn, items);
                            if (errorList == null) {
                                Integer userId = ((TblAccountDTO) session.getAttribute("ACCOUNT")).getId();
                                Date date = new Date();
                                TblOrderDAO orderDAO = new TblOrderDAO();
                                boolean result = orderDAO.createOrder(cn, null, userId, 0f);
                                if (!result) {
                                    throw new SQLException("create Order null (tbl_Order)");
                                }
                                TblOrderDTO orderDTO = orderDAO.getBillByUserId(cn, userId);
                                if (orderDTO == null) {
                                    throw new SQLException("get orderDTO null");
                                }
                                Integer orderId = orderDTO.getOrderId();
                                Float total = 0f;
                                TblOrderProductDAO orderProductDAO = new TblOrderProductDAO();
                                for (Integer key : keys) {
                                    Integer quantity = items.get(key);
                                    result = orderProductDAO.addRecord1(cn, orderId, key, quantity);
                                    if (!result) {
                                        throw new SQLException("create OrderProduct fail");
                                    }
                                    TblProductDTO productDTO = productDAO.getItemById2(cn, key);
                                    if (productDTO == null) {
                                        throw new SQLException("get product by productId");
                                    }
                                    total += productDTO.getPrice() * quantity;
                                };
                                result = orderDAO.setTotalForBill(cn, orderId, userId, total);
                                if (!result) {
                                    cn.rollback();
                                } else {
                                    cn.commit();
                                    TblProductDAO dao = new TblProductDAO();
                                    dao.getListRecomment(null);
                                    request.setAttribute("RECOMMENT", dao.getList());
                                }
                                cn.close();
                                session.removeAttribute("CART");
                            } else {
                                request.setAttribute("ERRORLIST", errorList);
                                cn.close();
                            }
                        }

                    }
                }
                url = VIEW_CART_SERVLET;
            }
        } catch (NamingException ex) {
            log("Naming_Checkout: " + ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_Checkout: " + ex.getMessage());
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
