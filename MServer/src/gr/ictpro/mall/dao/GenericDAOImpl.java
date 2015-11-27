/**
 * 
 */
package gr.ictpro.mall.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
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
    @Override
    public void create(T item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(T item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#delete(int)
     */
    @SuppressWarnings("unchecked")
    @Override
    public void delete(ID id) {
	Session session = this.sessionFactory.getCurrentSession();
	T item = (T) session.get(getPersistentClass(), id);
	if (null != item) {
	    session.delete(item);
	}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#retrieveById(int)
     */
    @SuppressWarnings("unchecked")
    @Override
    public T retrieveById(ID id) {
	Session session = this.sessionFactory.getCurrentSession();
	T item = (T) session.get(getPersistentClass(), id);
	return item;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<T> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<T> l = session.createQuery("from " + getPersistentClass().getSimpleName()).list();
	return l;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<T> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(getPersistentClass());
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<T> l = criteria.list();
	return l;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<T> listByProperties(Map<String, Object> properties) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(getPersistentClass());
	for(String property: properties.keySet()) {
	    criteria.add(Restrictions.eq(property, properties.get(property)));
	}
	List<T> l = criteria.list();
	return l;
	
    }
}
