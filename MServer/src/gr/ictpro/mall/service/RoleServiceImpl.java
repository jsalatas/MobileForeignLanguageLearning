/**
 * 
 */
package gr.ictpro.mall.service;


import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.RoleDAOImpl;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class RoleServiceImpl implements RoleService {
	private RoleDAOImpl roleDAO;
	
	public void setRoleDAO(RoleDAOImpl roleDAO) {
		this.roleDAO = roleDAO;
	}

	@Transactional
	@Override
	public void create(Role item) {
		roleDAO.create(item);
	}

	@Transactional
	@Override
	public void update(Role item) {
		roleDAO.update(item);
	}

	@Transactional
	@Override
	public List<Role> listAll() {
		return roleDAO.listAll();
	}

	@Transactional
	@Override
	public Role retrieveById(int id) {
		return roleDAO.retrieveById(id);
	}

	@Transactional
	@Override
	public List<Role> listByProperty(String propertyName, Object propertyValue) {
		return roleDAO.listByProperty(propertyName, propertyValue);
	}

	@Transactional
	@Override
	public void delete(int id) {
		roleDAO.delete(id);
	}

}
