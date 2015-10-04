package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.GenericDAO;
import gr.ictpro.mall.model.User;

import java.io.Serializable;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Transactional;

public class GenericServiceImpl<T, ID extends Serializable> implements GenericService<T, ID> {

    private GenericDAO<T, ID> dao;
    
    public void setDao(GenericDAO<T, ID> dao) {
	this.dao = dao;
    }

    public GenericDAO<T, ID> getDao() {
	return this.dao;
    }

    @Transactional
    @Override
    public void create(T item) {
	dao.create(item);
    }

    @Transactional
    @Override
    public void update(T item) {
        dao.update(item);
    }

    @Transactional
    @Override
    public void delete(ID id) {
	dao.delete(id);
    }

    @Transactional
    @Override
    public T retrieveById(ID id) {
	return dao.retrieveById(id);
    }

    @Transactional
    @Override
    public List<T> listAll() {
	return dao.listAll();
    }

    @Transactional
    @Override
    public List<T> listByProperty(String propertyName, Object propertyValue) {
	return dao.listByProperty(propertyName, propertyValue);
    }

}
