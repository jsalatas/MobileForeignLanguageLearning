/**
 * 
 */
package gr.ictpro.mall.service;


import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.dao.RoleDAO;
import gr.ictpro.mall.model.Role;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class RoleServiceImpl implements RoleService {
	private RoleDAO roleDAO;
	
	public void setRoleDAO(RoleDAO roleDAO) {
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
	public Role retrieveById(Integer id) {
		return roleDAO.retrieveById(id);
	}

	@Transactional
	@Override
	public List<Role> listByProperty(String propertyName, Object propertyValue) {
		return roleDAO.listByProperty(propertyName, propertyValue);
	}

	@Transactional
	@Override
	public void delete(Integer id) {
		roleDAO.delete(id);
	}

}
