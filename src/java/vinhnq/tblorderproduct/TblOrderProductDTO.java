/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblorderproduct;

import java.io.Serializable;

/**
 *
 * @author Vinh
 */
public class TblOrderProductDTO implements Serializable{
    private Integer orderId;
    private Integer productId;
    private Integer amount;

    public TblOrderProductDTO() {
    }

    public TblOrderProductDTO(Integer orderId, Integer productId, Integer amount) {
        this.orderId = orderId;
        this.productId = productId;
        this.amount = amount;
    }

    /**
     * @return the orderId
     */
    public Integer getOrderId() {
        return orderId;
    }

    /**
     * @param orderId the orderId to set
     */
    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    /**
     * @return the productId
     */
    public Integer getProductId() {
        return productId;
    }

    /**
     * @param productId the productId to set
     */
    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    /**
     * @return the amount
     */
    public Integer getAmount() {
        return amount;
    }

    /**
     * @param amount the amount to set
     */
    public void setAmount(Integer amount) {
        this.amount = amount;
    }
    
}
