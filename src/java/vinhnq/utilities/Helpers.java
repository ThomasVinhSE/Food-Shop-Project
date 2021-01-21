/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.utilities;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author Vinh
 */
public class Helpers implements Serializable {
    public static Connection makeConnection() throws NamingException,SQLException
    {
        Context context = new InitialContext();
        Context tomcat = (Context) context.lookup("java:/comp/env");
        DataSource ds = (DataSource) tomcat.lookup("SE141125");
        Connection cn = ds.getConnection();
        return cn;
    }
    public static String randomString()
    {
        String result = "";
        for(int i = 0 ; i < 5 ; i++)
        {
            int number = ((int) (Math.random()*25))+97;
            result += String.valueOf((char) number);
        }
        return result;
    }
}
