/**
 * 
 */
package gr.ictpro.mall.service;


import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.UserDAOImpl;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Service
public class UserServiceImpl implements UserService {
	private UserDAOImpl userDAO;

	public void setUserDAO(UserDAOImpl userDAO) {
		this.userDAO = userDAO;
	}

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
	public User retrieveById(int id) {
		return userDAO.retrieveById(id);
	}

	@Transactional(readOnly=true)
	@Override
	public List<User> listByProperty(String propertyName, Object propertyValue) {
		return userDAO.listByProperty(propertyName, propertyValue);
	}

	@Transactional
	@Override
	public void delete(int id) {
		userDAO.delete(id);
	}
	
}
