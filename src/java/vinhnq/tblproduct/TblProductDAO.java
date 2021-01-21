/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblproduct;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.naming.NamingException;
import vinhnq.utilities.Helpers;

/**
 *
 * @author Vinh
 */
public class TblProductDAO implements Serializable {

    private List<TblProductDTO> list;

    public List<TblProductDTO> getList() {
        return list;
    }

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

    public boolean updateProduct(TblProductDTO dto) throws NamingException, SQLException {
        boolean result = false;
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Update tbl_Product set name = ?, description = ? ,"
                        + "price = ?, category = ?, quantity = ? " + (dto.getImage().equals("") ? "" : ", image = '" + dto.getImage() + "'") + "  where productId = ?";
                pst = cn.prepareStatement(sql);
                pst.setString(1, dto.getName());
                pst.setNString(2, dto.getDescription());
                pst.setFloat(3, dto.getPrice());
                pst.setInt(4, dto.getCategoryId());
                pst.setInt(5, dto.getQuantity());
                pst.setInt(6, dto.getProductId());

                result = pst.executeUpdate() > 0;
            }

        } finally {
            closeConnection(cn, pst, rs);
        }
        return result;
    }

    public void setList(List<TblProductDTO> list) {
        this.list = list;
    }

    public void getListRecomment(Map<Integer,Integer> map) throws NamingException, SQLException {
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        TblProductDTO dto = null;

        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "select b.productId,b.name,b.category,b.createDate,b.description,b.image,b.price,b.quantity,COUNT(a.productId) as soluong\n"
                        + "from tbl_OrderProduct a,tbl_Product b\n"
                        + "where a.productId = b.productId and b.quantity > 0 and b.status > 0\n"
                        + "group by a.productId,b.productId,b.name,b.category,b.createDate,b.description,b.image,b.price,b.quantity\n"
                        + "order by soluong desc \n"
                        + "offset 0 rows\n"
                        + "fetch next 5 rows only";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    int productId = rs.getInt("productId");
                    String name = rs.getString("name");
                    String image = rs.getString("image");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
                    Timestamp time = rs.getTimestamp("createDate");
                    Date date = new Date(time.getTime());
                    int categoryTmp = rs.getInt("category");
                    int quantity = rs.getInt("quantity");
                    dto = new TblProductDTO(productId, name, image, description, price, date, categoryTmp, quantity);
                    if (list == null) {
                        list = new ArrayList<>();
                    }
                    list.add(dto);
                }
                if (map != null) {
                    if (list != null && !list.isEmpty()) {
                        for (int i = 0; i < list.size(); i++) {
                            TblProductDTO product = list.get(i);
                            if (map.containsKey(product.getProductId())) {
                                int current = product.getQuantity() - map.get(product.getProductId());
                                product.setQuantity(current);
                            }
                        }
                    }
                }

            }
        } finally {
            closeConnection(cn, pst, rs);
        }

    }

    public void getListRecomment2(Integer userId,Map<Integer,Integer> map) throws NamingException, SQLException {
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        TblProductDTO dto = null;

        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "select c.productId,count(c.productId) as soluong,c.name,c.image,c.category,c.description,c.createDate,c.price,c.quantity\n"
                        + "from tbl_Order a, tbl_OrderProduct b, tbl_Product c\n"
                        + "where a.orderId = b.orderId and b.productId = c.productId and a.userId = ? and c.quantity > 0 and c.status > 0\n"
                        + "group by c.productId,c.name,c.image,c.category,c.description,c.createDate,c.price,c.quantity\n"
                        + "order by soluong desc\n"
                        + "offset 0 rows\n"
                        + "fetch next 5 rows only";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, userId);
                rs = pst.executeQuery();
                while (rs.next()) {
                    int productId = rs.getInt("productId");
                    String name = rs.getString("name");
                    String image = rs.getString("image");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
                    Timestamp time = rs.getTimestamp("createDate");
                    Date date = new Date(time.getTime());
                    int categoryTmp = rs.getInt("category");
                    int quantity = rs.getInt("quantity");
                    dto = new TblProductDTO(productId, name, image, description, price, date, categoryTmp, quantity);
                    if (list == null) {
                        list = new ArrayList<>();
                    }
                    list.add(dto);
                }
                if (map != null) {
                    if (list != null && !list.isEmpty()) {
                        for (int i = 0; i < list.size(); i++) {
                            TblProductDTO product = list.get(i);
                            if (map.containsKey(product.getProductId())) {
                                int current = product.getQuantity() - map.get(product.getProductId());
                                product.setQuantity(current);
                            }
                        }
                    }
                }

            }
        } finally {
            closeConnection(cn, pst, rs);
        }

    }

     public boolean updateStatus(Integer productId) throws NamingException, SQLException {
        boolean result = false;
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Update tbl_Product set status = 1 where productId = ?";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, productId);

                result = pst.executeUpdate() > 0;
            }

        } finally {
            closeConnection(cn, pst, rs);
        }
        return result;
    }
    public boolean deleleProduct(Integer productId) throws NamingException, SQLException {
        boolean result = false;
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Update tbl_Product set status = 0 where productId = ?";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, productId);

                result = pst.executeUpdate() > 0;
            }

        } finally {
            closeConnection(cn, pst, rs);
        }
        return result;
    }

    public int search2(String txtSearchValue, int category, float min, float max, int index, Map<Integer, Integer> map) throws SQLException, NamingException {
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        TblProductDTO dto = null;
        int size = 0;
        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Select COUNT(productId) as number "
                        + "from tbl_Product "
                        + "where ";
                sql += "(quantity > 0 AND status > 0) AND (";
                sql += txtSearchValue.equals("") ? "1 = 0 OR " : "name like '%" + txtSearchValue + "%' OR ";
                sql += category == 0 ? "category like '%' OR " : "category like '" + category + "' OR ";
                if (max == 0) {
                    sql += min == 0 ? "1 = 0 " : "price >= " + min;
                } else {
                    sql += min == 0 ? "" : " (price >= " + min + " AND ";
                }
                sql += max == 0 ? "" : min == 0 ? "price <= " + max : "price <= " + max + " ) ";
                sql += " )";
                System.out.println(sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                if (rs.next()) {
                    size = rs.getInt("number");
                    rs.close();
                    pst.close();
                }
                sql = "Select productId,name,image,description,price,createDate,category,quantity "
                        + "from tbl_Product "
                        + "where ";
                sql += "(quantity > 0 AND status > 0) AND (";
                sql += txtSearchValue.equals("") ? "1 = 0 OR " : "name like '%" + txtSearchValue + "%' OR ";
                sql += category == 0 ? "category like '%' OR " : "category like '" + category + "' OR ";
                if (max == 0) {
                    sql += min == 0 ? "1 = 0 " : "price >= " + min;
                } else {
                    sql += min == 0 ? "" : "price >= " + min + " AND ";
                }
                sql += max == 0 ? "" : "price <= " + max;
                sql += " ) ";
                sql += " order by createDate offset " + 6 * (index - 1) + " rows fetch next 6 rows only";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    int productId = rs.getInt("productId");
                    String name = rs.getString("name");
                    String image = rs.getString("image");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
                    Timestamp time = rs.getTimestamp("createDate");
                    Date date = new Date(time.getTime());
                    int categoryTmp = rs.getInt("category");
                    int quantity = rs.getInt("quantity");
                    dto = new TblProductDTO(productId, name, image, description, price, date, categoryTmp, quantity);
                    if (list == null) {
                        list = new ArrayList<>();
                    }
                    list.add(dto);
                }
                if (map != null) {
                    if (list != null && !list.isEmpty()) {
                        for (int i = 0; i < list.size(); i++) {
                            TblProductDTO product = list.get(i);
                            if (map.containsKey(product.getProductId())) {
                                int current = product.getQuantity() - map.get(product.getProductId());
                                product.setQuantity(current);
                            }
                        }
                    }
                }
            }
        } finally {
            closeConnection(cn, pst, rs);
        }
        return size;
    }

    public int searchForListUpdate(int category, int status, int index) throws NamingException, SQLException {
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        TblProductDTO dto = null;
        int size = 0;

        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Select COUNT(productId) as number "
                        + "from tbl_Product "
                        + "where " + (category == 0 ? "" : " category = ? and ") + "  status = ?";
                pst = cn.prepareStatement(sql);
                if (category == 0) {
                    pst.setBoolean(1, status > 0 ? true : false);
                } else {
                    pst.setInt(1, category);
                    pst.setBoolean(2, status > 0 ? true : false);
                }
                System.out.println(sql);
                rs = pst.executeQuery();
                if (rs.next()) {
                    size = rs.getInt("number");
                    rs.close();
                    pst.close();
                }
                sql = "Select productId,name,image,description,price,createDate,category,quantity,status   "
                        + "from tbl_Product "
                        + "where " + (category == 0 ? "" : " category = ? and ") + "  status = ? "
                        + "order by createDate offset " + 6 * (index - 1) + " rows fetch next 6 rows only";
                pst = cn.prepareStatement(sql);
                if (category == 0) {
                    pst.setBoolean(1, status > 0 ? true : false);
                } else {
                    pst.setInt(1, category);
                    pst.setBoolean(2, status > 0 ? true : false);
                }
                rs = pst.executeQuery();
                while (rs.next()) {
                    int productId = rs.getInt("productId");
                    String name = rs.getString("name");
                    String image = rs.getString("image");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
                    Timestamp time = rs.getTimestamp("createDate");
                    Date date = new Date(time.getTime());
                    int categoryTmp = rs.getInt("category");
                    int quantity = rs.getInt("quantity");
                    boolean statusTmp = rs.getBoolean("status");
                    dto = new TblProductDTO(productId, name, image, description, price, date, categoryTmp, quantity);
                    dto.setStatus(statusTmp);
                    if (list == null) {
                        list = new ArrayList<>();
                    }
                    list.add(dto);
                }
            }
        } finally {
            closeConnection(cn, pst, rs);
        }
        return size;
    }

    public boolean createProduct(TblProductDTO dto) throws NamingException, SQLException {
        boolean result = false;
        Connection cn = null;
        PreparedStatement pst = null;
        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Insert into tbl_Product(name,description,price,quantity,category,image) "
                        + "Values(?,?,?,?,?,?) ";
                pst = cn.prepareStatement(sql);
                pst.setString(1, dto.getName());
                pst.setNString(2, dto.getDescription());
                pst.setFloat(3, dto.getPrice());
                pst.setInt(4, dto.getQuantity());
                pst.setInt(5, dto.getCategoryId());
                pst.setString(6, dto.getImage());

                result = pst.executeUpdate() > 0;
            }
        } finally {
            closeConnection(cn, pst, null);
        }
        return result;
    }

    public List<Integer> checkOutCart(Connection cn, Map<Integer, Integer> items) throws NamingException, SQLException {
        PreparedStatement pst = null;
        boolean result = false;
        List<Integer> list = null;
        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Update tbl_Product "
                        + "Set quantity = quantity - ? "
                        + "Where productId = ? and quantity >= ?";
                pst = cn.prepareStatement(sql);
                Set<Integer> keys = items.keySet();
                for (Integer key : keys) {
                    int quantity = items.get(key);
                    pst.setInt(1, quantity);
                    pst.setInt(2, key);
                    pst.setInt(3, quantity);
                    result = pst.executeUpdate() > 0;
                    if (!result) {
                        if (list == null) {
                            list = new ArrayList<>();
                        }
                        list.add(key);
                    }
                }

            }
        } finally {
            closeConnection(null, pst, null);
        }

        return list;
    }

    public TblProductDTO getItemById(Integer productId) throws NamingException, SQLException {
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        TblProductDTO dto = null;

        try {
            cn = Helpers.makeConnection();
            if (cn != null) {
                String sql = "Select productId,name,image,description,price,createDate,category,quantity  "
                        + "from tbl_Product "
                        + "where productId = ?";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, productId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    String name = rs.getString("name");
                    String image = rs.getString("image");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
                    Timestamp time = rs.getTimestamp("createDate");
                    Date date = new Date(time.getTime());
                    int categoryTmp = rs.getInt("category");
                    int quantity = rs.getInt("quantity");
                    dto = new TblProductDTO(productId, name, image, description, price, date, categoryTmp, quantity);

                }
            }
        } finally {
            closeConnection(cn, pst, rs);
        }
        return dto;
    }

    public TblProductDTO getItemById2(Connection cn, Integer productId) throws SQLException {
        PreparedStatement pst = null;
        ResultSet rs = null;
        TblProductDTO dto = null;

        try {
            if (cn != null) {
                String sql = "Select productId,name,image,description,price,createDate,category,quantity "
                        + "from tbl_Product "
                        + "where productId = ?";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, productId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    String name = rs.getString("name");
                    String image = rs.getString("image");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
                    Timestamp time = rs.getTimestamp("createDate");
                    Date date = new Date(time.getTime());
                    int categoryTmp = rs.getInt("category");
                    int quantity = rs.getInt("quantity");
                    dto = new TblProductDTO(productId, name, image, description, price, date, categoryTmp, quantity);

                }
            }
        } finally {
            closeConnection(null, pst, rs);
        }
        return dto;
    }

}
