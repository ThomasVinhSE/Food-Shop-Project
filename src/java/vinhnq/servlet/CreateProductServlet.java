/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import vinhnq.tblproduct.TblProductDAO;
import vinhnq.tblproduct.TblProductDTO;
import vinhnq.utilities.Helpers;

/**
 *
 * @author Vinh
 */
@WebServlet(name = "CreateProductServlet", urlPatterns = {"/CreateProductServlet"})
@javax.servlet.annotation.MultipartConfig
public class CreateProductServlet extends HttpServlet {

    private final String ERROR_PAGE = "error.jsp";
    private final String UPDATE_SERVLET = "ChangeProductServlet";
    private final String CREATE_PAGE = "adminPage.jsp";

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

        String isUpdate = request.getParameter("ForUpdate");
        String txtName = request.getParameter("txtName");
        String txtDescription = request.getParameter("txtDescription");
        String txtPrice = request.getParameter("txtPrice");
        String txtCategory = request.getParameter("txtCategory");
        String txtQuantity = request.getParameter("txtQuantity");
        Part imageFile = request.getPart("txtFile");

        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                String path = "";
                int category = Integer.parseInt(txtCategory);
                if (imageFile != null && !imageFile.getSubmittedFileName().equals("")) {
                    FileOutputStream fileOutput = null;
                    InputStream fileInput = null;
                    File file = null;
                    ServletContext context = request.getServletContext();
                    String realPath = context.getRealPath(".");
                    System.out.println(realPath);
                    int split = realPath.lastIndexOf("build");
                    String projectPath = realPath.substring(0, split);
                    String randomName = Helpers.randomString();
                    String txtFile = imageFile.getSubmittedFileName();
                    int numberOfDotExtention = txtFile.lastIndexOf(".");
                    String extension = txtFile.substring(numberOfDotExtention);
                    String[] extensionFile = new String[]{"png", "jpg", "jpeg", "gif", "svg"};

                    boolean checkExtention = false;
                    for (String string : extensionFile) {
                        if (extension.endsWith(string)) {
                            checkExtention = true;
                            break;
                        }
                    }
                    if(!checkExtention)
                        throw new SQLException("image");
                    switch (txtCategory) {
                        case "1":
                            file = new File(projectPath + "/web/images/food/" + randomName + extension);
                            break;
                        case "2":
                            file = new File(projectPath + "/web/images/drink/" + randomName + extension);
                            break;
                        case "3":
                            file = new File(projectPath + "/web/images/vegetable/" + randomName + extension);
                            break;
                    }
                    if (!file.exists() || !file.isFile()) {
                        file.createNewFile();
                    }
                    fileInput = imageFile.getInputStream();
                    int size = fileInput.available();
                    byte[] byteStream = new byte[size];
                    for (int i = 0; i < size; i++) {
                        byteStream[i] = (byte) fileInput.read();
                    }
                    fileInput.close();
                    fileOutput = new FileOutputStream(file);
                    fileOutput.write(byteStream);
                    fileOutput.flush();
                    fileOutput.close();

                    int lastIndex = file.getAbsolutePath().lastIndexOf("\\images");
                    path = file.getAbsolutePath().substring(lastIndex);

                    path = path.replace("\\", "/");
                }
                float price = txtPrice.equals("") ? 0 : Float.parseFloat(txtPrice);
                int quantity = txtQuantity.equals("") ? 0 : Integer.parseInt(txtQuantity);
                TblProductDTO dto = new TblProductDTO(0, txtName, path.equals("") ? "" : "." + path, txtDescription, price, null, category, quantity);
                TblProductDAO dao = new TblProductDAO();
                if (isUpdate == null) {
                    boolean result = dao.createProduct(dto);
                    if (result) {
                        url = CREATE_PAGE;
                        request.setAttribute("FILE", path);
                    }
                } else {
                    String txtProductId = request.getParameter("txtProductId");
                    dto.setProductId(Integer.parseInt(txtProductId));
                    request.setAttribute("DTO", dto);
                    url = UPDATE_SERVLET;
                }
            }
        } catch (NumberFormatException e) {
            log("NumberFormat_Create: " + e.getMessage());
            request.setAttribute("MESSAGE", "Điền sai kiểu format của số nguyên");
        } catch (NamingException ex) {
            log("Naming_Create: " + ex.getMessage());
        } catch (SQLException ex) {
            log("SQL_Create: " + ex.getMessage());
            if(ex.getMessage().contains("image"))
                request.setAttribute("MESSAGE", "Không phải định dạng ảnh được yêu cầu !!!");
            else
                request.setAttribute("MESSAGE", "Không thể tạo product ngay bây giờ, thử lại sau");
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
