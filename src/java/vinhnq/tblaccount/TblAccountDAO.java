/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblaccount;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.NamingException;
import vinhnq.utilities.Helpers;

/**
 *
 * @author Vinh
 */
public class TblAccountDAO implements Serializable {

    private void closeConnection(Connection cn, PreparedStatement pst, ResultSet rs) throws SQLException {
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
    public TblAccountDTO checkLoginGoogle(String email) throws NamingException, SQLException {
        boolean result = false;
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        TblAccountDTO dto = null;
        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "select userId,username,lastname,tokenKey,role from tbl_Account where "
                        + "username = ? and role = 2";
                pst = cn.prepareStatement(sql);
                pst.setString(1, email);
                rs = pst.executeQuery();
                if (rs.next()) {
                    int userId = rs.getInt("userId");
                    String lastname = rs.getNString("lastname");
                    String token = rs.getString("tokenKey");
                    int role = rs.getInt("role");
                    dto = new TblAccountDTO(userId, email,"", lastname, token, role);
                }

            }
        } finally {
            closeConnection(cn, pst, rs);
        }
        return dto;
    }

    public TblAccountDTO checkLogin(String username, String password) throws NamingException, SQLException {
        boolean result = false;
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        TblAccountDTO dto = null;
        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "select userId,username,password,lastname,tokenKey,role from tbl_Account where "
                        + "username = ? and password = ? and role != 2";
                pst = cn.prepareStatement(sql);
                pst.setString(1, username);
                pst.setString(2, password);
                rs = pst.executeQuery();
                if (rs.next()) {
                    int userId = rs.getInt("userId");
                    String lastname = rs.getNString("lastname");
                    String token = rs.getString("tokenKey");
                    int role = rs.getInt("role");
                    dto = new TblAccountDTO(userId, username, password, lastname, token, role);
                }

            }
        } finally {
            closeConnection(cn, pst, rs);
        }
        return dto;
    }
}
