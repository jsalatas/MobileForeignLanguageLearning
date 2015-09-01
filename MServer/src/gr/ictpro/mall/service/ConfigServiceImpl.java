/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.ConfigDAOImpl;
import gr.ictpro.mall.model.Config;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Service
public class ConfigServiceImpl implements ConfigService {
    private ConfigDAOImpl configDAO;

    public void setConfigDAO(ConfigDAOImpl configDAO) {
	this.configDAO = configDAO;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(Config item) {
	configDAO.create(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(Config item) {
	configDAO.update(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#delete(int)
     */
    @Transactional
    @Override
    public void delete(Integer id) {
	configDAO.delete(id);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#retrieveById(int)
     */
    @Transactional
    @Override
    public Config retrieveById(Integer id) {
	return configDAO.retrieveById(id);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<Config> listAll() {
	return configDAO.listAll();
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
    public List<Config> listByProperty(String propertyName, Object propertyValue) {
	return configDAO.listByProperty(propertyName, propertyValue);
    }

}
