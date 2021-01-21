/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.naming.NamingException;
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
@WebServlet(name = "AJAXProductServlet", urlPatterns = {"/AJAXProductServlet"})
public class AJAXProductServlet extends HttpServlet {

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
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        String jsonString = request.getParameter("txtProducId");
        
        try
        {
            if(jsonString != null)
            {
                int id = Integer.parseInt(jsonString);
                TblProductDAO dao = new TblProductDAO();
                TblProductDTO dto = dao.getItemById(id);
                String json = "{quantity:"+dto.getQuantity()+"}";
                JsonParser parse = new JsonParser();
                JsonElement jsonResponse = parse.parse(json);
                out.print(jsonResponse);
            }
        }
        catch(NumberFormatException e)
        {
            log("NumberFormat_AJAX: "+e.getMessage());
        } catch (NamingException ex) {
            log("Naming_AJAX: "+ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_AJAX: "+ex.getMessage());
        }
        finally{
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
