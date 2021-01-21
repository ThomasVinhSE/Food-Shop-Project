/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblorderproduct;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.naming.NamingException;

/**
 *
 * @author Vinh
 */
public class TblOrderProductDAO implements Serializable {

    private List<TblOrderProductDTO> list;

    public List<TblOrderProductDTO> getList() {
        return list;
    }
    
   
    public boolean addRecord1(Connection cn, Integer orderId, Integer productId, Integer amount) throws SQLException {
        boolean result = false;
        PreparedStatement pst = null;
        try {
            if (cn != null) {
                String sql = "Insert into tbl_OrderProduct VALUES(?,?,?)";
                pst = cn.prepareStatement(sql);

                pst.setInt(1, orderId);
                pst.setInt(2, productId);
                pst.setInt(3, amount);

                result = pst.executeUpdate() > 0 ? true : false;
            }
        } finally {
            if (pst != null) {
                pst.close();
            }
        }
        return result;
    }

    public boolean addRecord2(Connection cn, TblOrderProductDTO dto) throws SQLException {
        boolean result = false;
        PreparedStatement pst = null;
        try {
            if (cn != null && dto != null) {
                String sql = "Insert into tbl_OrderProduct VALUES(?,?,?)";
                pst = cn.prepareStatement(sql);

                pst.setInt(1, dto.getOrderId());
                pst.setInt(2, dto.getProductId());
                pst.setInt(3, dto.getAmount());

                result = pst.executeUpdate() > 0 ? true : false;
            }
        } finally {
            if (pst != null) {
                pst.close();
            }
        }
        return result;
    }
    public void makeList(Connection cn,PreparedStatement pst,Integer orderId) throws NamingException, SQLException {
        ResultSet rs = null;
        TblOrderProductDTO dto = null;
        
        try {
            if(cn != null)
            {
                String sql = "Select productId,amount from tbl_OrderProduct where orderId = ? ";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, orderId);
                rs = pst.executeQuery();
                while(rs.next())
                {
                    
                    Integer productId = rs.getInt("productId");
                    Integer amount = rs.getInt("amount");
                    dto = new TblOrderProductDTO(orderId, productId, amount);
                    if(list == null)
                        list = new ArrayList<>();
                    list.add(dto);
                }
            }

        } finally {
            if(rs != null)
                rs.close();
        }
    }
   
}
