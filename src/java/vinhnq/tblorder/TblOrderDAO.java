/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblorder;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.naming.NamingException;
import vinhnq.tblproduct.TblProductDTO;
import vinhnq.utilities.Helpers;

/**
 *
 * @author Vinh
 */
public class TblOrderDAO implements Serializable {

    private List<TblOrderDTO> list;
    private Map<TblProductDTO, Integer> detailMap;

    public Map<TblProductDTO, Integer> getDetailMap() {
        return detailMap;
    }

    public List<TblOrderDTO> getList() {
        return list;
    }

    public boolean createOrder(Connection cn, String nameOfOrder, Integer userId, Float total) throws SQLException {
        boolean result = false;
        PreparedStatement pst = null;
        try {
            if (cn != null) {
                String sql = "Insert into tbl_Order(name,userId,total) Values(?,?,?)";
                pst = cn.prepareStatement(sql);
                if (nameOfOrder == null || nameOfOrder.equals("")) {
                    pst.setNString(1, "Hóa Đơn Mua Hàng");
                } else {
                    pst.setNString(1, nameOfOrder);
                }
                pst.setInt(2, userId);
                pst.setFloat(3, total);
                result = pst.executeUpdate() > 0 ? true : false;
            }

        } finally {
            if (pst != null) {
                pst.close();
            }
        }
        return result;
    }

    public boolean setTotalForBill(Connection cn, Integer orderId, Integer userId, Float total) throws SQLException {
        boolean result = false;

        PreparedStatement pst = null;
        try {
            if (cn != null) {
                String sql = "Update tbl_Order Set total = ? Where orderId = ? And userId = ?";
                pst = cn.prepareStatement(sql);
                pst.setFloat(1, total);
                pst.setInt(2, orderId);
                pst.setInt(3, userId);
                result = pst.executeUpdate() > 0 ? true : false;
            }
        } finally {
            if (pst != null) {
                pst.close();
            }
        }

        return result;
    }

    public TblOrderDTO getBillByUserId(Connection cn, Integer userId) throws SQLException {
        TblOrderDTO dto = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            if (cn != null) {
                String sql = "Select orderId,name,buyDate,userId,total from tbl_Order where userId = ? and buyDate "
                        + ">= all (Select max(buyDate) from tbl_Order)";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, userId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    Integer orderId = rs.getInt("orderId");
                    String name = rs.getNString("name");
                    Timestamp time = rs.getTimestamp("buyDate");
                    Date buyDate = new Date(time.getTime());
                    Float total = rs.getFloat("total");

                    dto = new TblOrderDTO(orderId, name, buyDate, userId, total);
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
        }
        return dto;
    }

    public void getOrderHistory(Integer userId, String searchByName, Date searchByDate) throws NamingException, SQLException {
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        TblOrderDTO dto = null;
        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Select orderId,name,buyDate,userId,total from tbl_Order where userId = ? ";
                sql += searchByName == null || searchByName.equals("") ?
                        "" : searchByDate == null || searchByDate.equals("") ?
                        " AND orderId = " + searchByName + " " : " AND ( orderId =  " + searchByName + " ";
                sql += searchByDate == null || searchByDate.equals("") ? "" : searchByName == null || searchByName.equals("")
                        ? " AND CONVERT(DATE,buyDate) = ? " : " OR CONVERT(DATE,buyDate) = ? )";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, userId);
                System.out.println(sql);
                if (searchByDate != null) {
                    Timestamp time = new Timestamp(searchByDate.getTime());
                    pst.setTimestamp(2, time);
                }
                rs = pst.executeQuery();
                while (rs.next()) {
                    Integer orderId = rs.getInt("orderId");
                    String name = rs.getNString("name");
                    Timestamp time = rs.getTimestamp("buyDate");
                    Date buyDate = new Date(time.getTime());
                    Float total = rs.getFloat("total");
                    dto = new TblOrderDTO(orderId, name, buyDate, userId, total);
                    if (list == null) {
                        list = new ArrayList<>();
                    }
                    list.add(dto);
                }
            }

        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
            if (cn != null) {
                cn.close();
            }
        }
    }

    public void getFinalDetailMap(Integer orderId) throws NamingException, SQLException {
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "select a.productId,a.name,a.image,a.description,a.createDate,a.quantity,a.category,a.price,b.amount from tbl_Product a ,tbl_OrderProduct b "
                        + "where a.productId = b.productId and b.orderId = ?";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, orderId);
                rs = pst.executeQuery();
                while (rs.next()) {
                    Integer productId = rs.getInt("productId");
                    String name = rs.getString("name");
                    String image = rs.getString("image");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
                    Timestamp time = rs.getTimestamp("createDate");
                    Date date = new Date(time.getTime());
                    int categoryTmp = rs.getInt("category");
                    int quantity = rs.getInt("quantity");
                    int amount = rs.getInt("amount");
                    TblProductDTO dto = new TblProductDTO(productId, name, image, description, price, date, categoryTmp, quantity);
                    if (detailMap == null) {
                        detailMap = new HashMap<>();
                    }
                    detailMap.put(dto, amount);
                }
            }

        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
            if (cn != null) {
                cn.close();
            }
        }
    }

}
