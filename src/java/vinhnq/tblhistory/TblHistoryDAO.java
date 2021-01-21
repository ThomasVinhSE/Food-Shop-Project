/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblhistory;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.naming.NamingException;
import vinhnq.utilities.Helpers;

/**
 *
 * @author Vinh
 */
public class TblHistoryDAO implements Serializable{
    
    public boolean backupAction(Integer userId ,String message) throws NamingException,SQLException
    {
        Connection cn = null;
        PreparedStatement pst = null;
        boolean result = false;
        try
        {
            cn = Helpers.makeConnection();
            if(cn != null)
            {
                String sql = "Insert into tbl_History(userId,description) Values(?,?)";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, userId);
                pst.setNString(2, message);
                result = pst.executeUpdate() > 0;
            }
        }
        finally{
            if(pst != null)
                pst.close();
            if(cn != null)
                cn.close();
        }
        return result;
    }
}
