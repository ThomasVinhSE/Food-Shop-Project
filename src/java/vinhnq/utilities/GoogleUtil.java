/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.utilities;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Serializable;
import java.net.URL;
import java.net.URLConnection;
import org.json.JSONObject;
import org.json.JSONTokener;

/**
 *
 * @author Vinh
 */
public class GoogleUtil implements Serializable   {

    //public static final String GOOGLE_CLIENT_ID = "1066485509181-g226gik0baf97igo1p4pn1o405bivm20.apps.googleusercontent.com";
    //public static final String GOOGLE_CLIENT_SECRECT = "LEwSRQsnP83NglBsl1FJ0FoW";
    public static final String GOOGLE_CLIENT_ID = "946174400774-qb5n6hkf4fm3ni69io6p6s39vp39dsgh.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRECT = "TGgC12p8UP2VrWuKpHnvLoVX";
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/lab1/DispatcherServlet?btnAction=Login";
    public static final String GOOGLE_GET_TOKEN = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_GET_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    public static final String GOOGLE_GRANT_TYPE = "authorization_code";
   
    public static String getToken(String code)  throws Exception{
            
        URL url = new URL(GOOGLE_GET_TOKEN);
        URLConnection connection = url.openConnection();
        if(connection != null)
        {
            connection.setDoOutput(true);
            OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
            String urlParameters = "code="+code
                    + "&client_id="+GOOGLE_CLIENT_ID
                    + "&client_secret="+GOOGLE_CLIENT_SECRECT
                    + "&redirect_uri="+GOOGLE_REDIRECT_URI
                    + "&grant_type="+ GOOGLE_GRANT_TYPE;
            writer.write(urlParameters);
            writer.flush();
            BufferedReader bf = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            JSONTokener tokener = new JSONTokener(bf);
            JSONObject json = new JSONObject(tokener);
            return json.getString("access_token");
        }
        return "";
    }
    
    public static String getInfoOfUser(String code) throws Exception
    {
        String info = getToken(code);
        if(info != null || !info.isEmpty())
        {
            URL url = new URL(GOOGLE_GET_INFO+info);
            URLConnection con = url.openConnection();
            BufferedReader bf = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONTokener token = new JSONTokener(bf);
            JSONObject json = new JSONObject(token);
            return json.getString("email");
        }
        return "";
    }
    

}
