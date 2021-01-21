/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.utilities;

import com.google.gson.JsonParser;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Serializable;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import org.json.JSONObject;
import org.json.JSONTokener;

/**
 *
 * @author Vinh
 */
public class PayPalUtil implements Serializable {

    private final String SECRET_KEY = "EBl_tgF2MmpgwIYGEgWYb8XmaOdSQ6P5QQhVadkkUCGvTpgqy6L-T5fI6aMMtW5jqLQYKWdkaRPS3tCD";
    private final String CLIENT_ID = "ATJNTjJErAxh5Vcme_WM9no11_qHUjdKn9r9UfnV6Xv2RbYXFwKZvFO4XtFEauZn3o9QzGfERUyw28uo";
    private final String ACCESS_TOKEN = "access_token$sandbox$7fkbkfc4hm23spzm$3464a8804863bf9e4dee4bb1dcb83796";
    private final String MERCHANT_ID = "KYFZK8RALJJL6";
    private final String PAYPAL_API = "https://api-m.sandbox.paypal.com";
    private final String TOKEN = "https://api-m.sandbox.paypal.com/v1/oauth2/token";

    public String getAccessToken() throws Exception {
        URL url = new URL(TOKEN);
        HttpURLConnection http = (HttpURLConnection) url.openConnection();
        http.setRequestMethod("POST");
        http.setRequestProperty("Content-Type", "application/json");
        String auth = CLIENT_ID + ":" + SECRET_KEY;
        byte[] encodeAuth = Base64.getEncoder().encode(auth.getBytes(StandardCharsets.UTF_8));
        String authBasic = "Basic " + new String(encodeAuth);
        http.setRequestProperty("Authorization", authBasic);
        http.setDoOutput(true);
        OutputStreamWriter writer = new OutputStreamWriter(http.getOutputStream());
        writer.write("grant_type=client_credentials");
        writer.flush();

        BufferedReader bf = new BufferedReader(new InputStreamReader(http.getInputStream()));
        JSONTokener tokener = new JSONTokener(bf);
        JSONObject json = new JSONObject(tokener);
        return json != null ? json.getString("access_token") : "";
    }

    public String getPaymentId(String access_token, float total) throws Exception {
        URL url = new URL("https://api-m.sandbox.paypal.com/v1/payments/payment");
        HttpURLConnection http = (HttpURLConnection) url.openConnection();
        http.setRequestMethod("POST");
        http.setRequestProperty("Content-Type", "application/json");
        String authBasic = "Bearer " + access_token;
        http.setRequestProperty("Authorization", authBasic);
        String data = "{\n"
                + "  \"intent\": \"sale\",\n"
                + "  \"payer\": {\n"
                + "    \"payment_method\": \"paypal\"\n"
                + "  },\n"
                + "  \"transactions\": [\n"
                + "    {\n"
                + "      \"amount\": {\n"
                + "        \"total\": \"" + total + "\",\n"
                + "        \"currency\": \"USD\"\n"
                + "      }\n"
                + "      }"
                + "  ],\n"
                + "  \"note_to_payer\": \"Contact Vinh Shop.\",\n"
                + "  \"redirect_urls\": {\n"
                + "    \"return_url\": \"http://localhost:8080/lab1/DispatcherServlet?btnAction=Cart\",\n"
                + "    \"cancel_url\": \"http://localhost:8080/lab1/DispatcherServlet?btnAction=Cart\"\n"
                + "  }\n"
                + "}";
        http.setDoOutput(true);
        OutputStreamWriter writer = new OutputStreamWriter(http.getOutputStream());
        writer.write(data);
        writer.flush();
        BufferedReader bf = new BufferedReader(new InputStreamReader(http.getInputStream()));
        JSONTokener tokener = new JSONTokener(bf);
        JSONObject json = new JSONObject(tokener);
//        Set<String> set = json.keySet();
        String pay_id = json.getString("id");
//        JSONArray array = json.getJSONArray("links");
//        JSONObject object = array.getJSONObject(1);
//        String redirect = (String) object.get("href");
        return json != null ? json.getString("id") : null;
    }

    public String executePayment(String access_token, String paymentID, String payerId, float total) throws Exception {
        URL url = new URL(PAYPAL_API + "/v1/payments/payment/" + paymentID + "/execute");
        HttpURLConnection http = (HttpURLConnection) url.openConnection();
        http.setRequestMethod("POST");
        http.setRequestProperty("Content-Type", "application/json");
        String auth = "Bearer " + access_token;
        http.setRequestProperty("Authorization", auth);
        String data = "{\n"
                + "          payer_id: " + payerId + ",\n"
                + "          transactions: [\n"
                + "          {\n"
                + "            amount:\n"
                + "            {\n"
                + "              total: '" + total + "',\n"
                + "              currency: 'USD'\n"
                + "            }\n"
                + "          }]\n"
                + "      }";
//        String data = "{\n"
//                + "        'auth':\n"
//                + "        {\n"
//                + "          'user': 'ATJNTjJErAxh5Vcme_WM9no11_qHUjdKn9r9UfnV6Xv2RbYXFwKZvFO4XtFEauZn3o9QzGfERUyw28uo',\n"
//                + "          'pass': 'EBl_tgF2MmpgwIYGEgWYb8XmaOdSQ6P5QQhVadkkUCGvTpgqy6L-T5fI6aMMtW5jqLQYKWdkaRPS3tCD'\n"
//                + "        },\n"
//                + "        'body':\n"
//                + "        {\n"
//                + "          'payer_id': '" + payerId + "',\n"
//                + "          'transactions': [\n"
//                + "          {\n"
//                + "            'amount':\n"
//                + "            {\n"
//                + "              'total': '" + total + "',\n"
//                + "              'currency': 'USD'\n"
//                + "            }\n"
//                + "          }]\n"
//                + "        },\n"
//                + "        'json': true\n"
//                + "      }";
        JsonParser parse = new JsonParser();
        http.setDoOutput(true);
        OutputStreamWriter writer = new OutputStreamWriter(http.getOutputStream());
        writer.write(parse.parse(data).toString());
        writer.flush();
        BufferedReader bf = new BufferedReader(new InputStreamReader(http.getInputStream()));
        JSONTokener tokener = new JSONTokener(bf);
        JSONObject jsonObject = new JSONObject(tokener);
        return jsonObject != null ? jsonObject.getString("state") : "";
    }
//    public static void main(String[] args) {
//        try {
//            PayPalUtil util = new PayPalUtil();
//            String access_token = util.getAccessToken();
//            String[] response = util.getPaymentId(access_token, 30);
//            for (String string : response) {
//                System.out.println(string);
//            }
//        } catch (Exception ex) {
//            Logger.getLogger(PayPalUtil.class.getName()).log(Level.SEVERE, null, ex);
//        }
//    }
}
