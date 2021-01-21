/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblproduct;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Vinh
 */
public class TblProductDTO implements Serializable{
    private int productId;
    private String name;
    private String image;
    private String description;
    private float price;
    private Date createDate;
    private int categoryId;
    private int quantity;
    private boolean status;
    public TblProductDTO() {
    }
    public String passTime()
    {
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
        return format.format(createDate);
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    public   String passCategory()
    {
        switch(categoryId)
        {
            case 1:
                return "Food";
            case 2:
                return "Drink";
            case 3:
                return "Vegetable";
        }
        return "";
    }
    public TblProductDTO(int productId, String name, String image, String description, float price, Date createDate, int categoryId, int quantity) {
        this.productId = productId;
        this.name = name;
        this.image = image;
        this.description = description;
        this.price = price;
        this.createDate = createDate;
        this.categoryId = categoryId;
        this.quantity = quantity;
    }

    /**
     * @return the productId
     */
    public int getProductId() {
        return productId;
    }

    /**
     * @param productId the productId to set
     */
    public void setProductId(int productId) {
        this.productId = productId;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the image
     */
    public String getImage() {
        return image;
    }

    /**
     * @param image the image to set
     */
    public void setImage(String image) {
        this.image = image;
    }
    
    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return the price
     */
    public float getPrice() {
        return price;
    }

    /**
     * @param price the price to set
     */
    public void setPrice(float price) {
        this.price = price;
    }

    /**
     * @return the createDate
     */
    public Date getCreateDate() {
        return createDate;
    }

    /**
     * @param createDate the createDate to set
     */
    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    /**
     * @return the categoryId
     */
    public int getCategoryId() {
        return categoryId;
    }

    /**
     * @param categoryId the categoryId to set
     */
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    /**
     * @return the quantity
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * @param quantity the quantity to set
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "TblProductDTO{" + "productId=" + productId + ", name=" + name + ", image=" + image + ", description=" + description + ", price=" + price + ", createDate=" + createDate + ", categoryId=" + categoryId + ", quantity=" + quantity + '}';
    }

   
    
    
}
