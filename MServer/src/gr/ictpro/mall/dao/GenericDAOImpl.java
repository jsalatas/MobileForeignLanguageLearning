/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.interceptors.PersistentObjectModifier;
import gr.ictpro.mall.utils.hibernate.DatabaseGeneratedValues;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class GenericDAOImpl<T, ID extends Serializable> implements GenericDAO<T, ID> {
    @Autowired(required=true)
    private SessionFactory sessionFactory;
    private Class<T> persistentClass;
    @SuppressWarnings("unused")
    private Class<ID> idClass;
    
    public GenericDAOImpl(Class<T> t, Class<ID> id) {  
        this.persistentClass = t;
        this.idClass = id;
     }  
  

    public Class<T> getPersistentClass() {  
        return persistentClass;  
    }  
    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#create(java.lang.Object)
     */
    @PersistentObjectModifier
    public void create(T item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
	if(item instanceof DatabaseGeneratedValues) {
	    session.flush(); // make sure session is flushed before reloading
	    session.refresh(item);
	}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#update(java.lang.Object)
     */
    @PersistentObjectModifier
    public void update(T item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
	//if(item instanceof DatabaseGeneratedValues) {
	    session.flush(); // make sure session is flushed before reloading
	    session.refresh(item);
	//}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#delete(int)
     */
    @PersistentObjectModifier
    public void delete(T item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.delete(item);
	session.flush();
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#retrieveById(int)
     */
    @SuppressWarnings("unchecked")
    public T retrieveById(ID id) {
	Session session = this.sessionFactory.getCurrentSession();
	T item = (T) session.get(getPersistentClass(), id);
	return item;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    public List<T> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<T> l = session.createQuery("from " + getPersistentClass().getSimpleName()).list();
	return l;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    public List<T> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(getPersistentClass());
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<T> l = criteria.list();
	return l;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listByProperties(java.util.Map)
     */
    @SuppressWarnings("unchecked")
    public List<T> listByProperties(Map<String, Object> properties) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(getPersistentClass());
	for(String property: properties.keySet()) {
	    criteria.add(Restrictions.eq(property, properties.get(property)));
	}
	List<T> l = criteria.list();
	return l;
	
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#execSQL(java.lang.String)
     */
    public void execSQL(String sql) {
	Session session = this.sessionFactory.getCurrentSession();
	Query q = session.createQuery(sql);
	q.executeUpdate();
    }
    
    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listByCustomSQL(java.lang.String)
     */
    @SuppressWarnings("unchecked")
    public List<T> listByCustomSQL(String sql) {
	Session session = this.sessionFactory.getCurrentSession();
	Query q = session.createQuery(sql);
	List<T> l = q.list();
	return l;
    }
}
