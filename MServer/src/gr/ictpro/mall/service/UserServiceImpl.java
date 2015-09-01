/**
 * 
 */
package gr.ictpro.mall.service;


import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.dao.UserDAO;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Service
public class UserServiceImpl implements UserService {
	private UserDAO userDAO;

	public void setUserDAO(UserDAO userDAO) {
		this.userDAO = userDAO;
	}

	@Autowired
	private RoleService roleService;

	@Transactional
	@Override
	public void create(User item) {
		userDAO.create(item);
	}

	@Transactional
	@Override
	public void update(User item) {
		userDAO.update(item);
	}

	@Transactional
	@Override
	public List<User> listAll() {
		return userDAO.listAll();
	}

	@Transactional(readOnly=true)
	@Override
	public User retrieveById(Integer id) {
		return userDAO.retrieveById(id);
	}

	@Transactional(readOnly=true)
	@Override
	public List<User> listByProperty(String propertyName, Object propertyValue) {
		return userDAO.listByProperty(propertyName, propertyValue);
	}

	@Transactional
	@Override
	public void delete(Integer id) {
		userDAO.delete(id);
	}
	
	@Transactional
	@Override
	public List<User> getUserByRole(String role) {
	    return getUserByRole(roleService.listByProperty("role", role).get(0));
	}

	@Transactional
	@Override
	public List<User> getUserByRole(Role role) {
	    List<User> res = new ArrayList<User>();
	    
	    for(User u: role.getUsers()) {
		res.add(u);
	    }
	    
	    return res;
	}
}
