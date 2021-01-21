/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.tblaccount;

import java.io.Serializable;

/**
 *
 * @author Vinh
 */
public class TblAccountDTO implements Serializable{
    private int userId;
    private String username;
    private String password;
    private String lastname;
    private String tokenKey;
    private int role;

    public TblAccountDTO() {
    }

    public TblAccountDTO(int userId, String username, String password, String lastname, String tokenKey, int role) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.lastname = lastname;
        this.tokenKey = tokenKey;
        this.role = role;
    }

    /**
     * @return the id
     */
    public int getId() {
        return userId;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.userId = id;
    }

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @return the lastname
     */
    public String getLastname() {
        return lastname;
    }

    /**
     * @param lastname the lastname to set
     */
    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    /**
     * @return the tokenKey
     */
    public String getTokenKey() {
        return tokenKey;
    }

    /**
     * @param tokenKey the tokenKey to set
     */
    public void setTokenKey(String tokenKey) {
        this.tokenKey = tokenKey;
    }

    /**
     * @return the type
     */
    /**
     * @return the role
     */
    public int getRole() {
        return role;
    }

    /**
     * @param role the role to set
     */
    public void setRole(int role) {
        this.role = role;
    }
    
}
