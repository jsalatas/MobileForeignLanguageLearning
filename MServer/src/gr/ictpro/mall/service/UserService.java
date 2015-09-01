/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.List;

import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public interface UserService extends GenericService<User, Integer> {
    public List<User> getUserByRole(Role role);
    public List<User> getUserByRole(String role);
}