/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.ProfileDAO;
import gr.ictpro.mall.model.Profile;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class ProfileServiceImpl implements ProfileService {
    private ProfileDAO profileDAO;

    public void setProfileDAO(ProfileDAO profileDAO) {
	this.profileDAO = profileDAO;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(Profile item) {
	profileDAO.create(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(Profile item) {
	profileDAO.update(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#delete(int)
     */
    @Transactional
    @Override
    public void delete(Integer id) {
	profileDAO.delete(id);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#retrieveById(int)
     */
    @Transactional
    @Override
    public Profile retrieveById(Integer id) {
	return profileDAO.retrieveById(id);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<Profile> listAll() {
	return profileDAO.listAll();
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * gr.ictpro.mall.service.GenericService#listByProperty(java.lang.String,
     * java.lang.Object)
     */
    @Transactional
    @Override
    public List<Profile> listByProperty(String propertyName, Object propertyValue) {
	return profileDAO.listByProperty(propertyName, propertyValue);
    }

}
