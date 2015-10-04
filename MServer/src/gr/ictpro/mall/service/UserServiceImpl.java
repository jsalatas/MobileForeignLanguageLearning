/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Service
public class UserServiceImpl extends GenericServiceImpl<User, Integer> implements UserService {
    @Autowired(required=true)
    private GenericService<Role, Integer> roleService;

    @Transactional
    @Override
    public List<User> getUserByRole(String role) {
	return getUserByRole(roleService.listByProperty("role", role).get(0));
    }

    @Transactional
    @Override
    public List<User> getUserByRole(Role role) {
	List<User> res = new ArrayList<User>();

	for (User u : role.getUsers()) {
	    res.add(u);
	}

	return res;
    }
}
