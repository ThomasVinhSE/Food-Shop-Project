/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vinhnq.cart;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Vinh
 */
public class CartObject implements Serializable{
    private Map<Integer,Integer> items;

    public Map<Integer, Integer> getMap() {
        return items;
    }

    public void addItem(Integer id,Integer quantity)
    {
       if(items == null)
           items = new HashMap<>();
       int number = quantity;
       if(items.containsKey(id))
       {
           number = items.get(id)+quantity;
       }
       items.put(id, number);
    }
    public void removeItem(Integer id)
    {
        if(items != null)
        {
            if(items.containsKey(id))
                items.remove(id);
            if(items.isEmpty())
                items = null;
        }
    }
}
