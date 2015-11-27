/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.GenericDAO;
import gr.ictpro.mall.model.User;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class GenericServiceImpl<T, ID extends Serializable> implements GenericService<T, ID> {

    private GenericDAO<T, ID> dao;
    
    public void setDao(GenericDAO<T, ID> dao) {
	this.dao = dao;
    }

    public GenericDAO<T, ID> getDao() {
	return this.dao;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(T item) {
	dao.create(item);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(T item) {
        dao.update(item);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#delete(java.io.Serializable)
     */
    @Transactional
    @Override
    public void delete(ID id) {
	dao.delete(id);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#retrieveById(java.io.Serializable)
     */
    @Transactional
    @Override
    public T retrieveById(ID id) {
	return dao.retrieveById(id);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<T> listAll() {
	return dao.listAll();
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listByProperty(java.lang.String, java.lang.Object)
     */
    @Transactional
    @Override
    public List<T> listByProperty(String propertyName, Object propertyValue) {
	return dao.listByProperty(propertyName, propertyValue);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listByProperties(java.util.Map)
     */
    @Transactional
    @Override
    public List<T> listByProperties(Map<String, Object> properties) {
	return dao.listByProperties(properties);
    }
}
