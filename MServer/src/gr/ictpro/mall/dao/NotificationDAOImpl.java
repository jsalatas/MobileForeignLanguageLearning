/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.Notification;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class NotificationDAOImpl implements NotificationDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.model.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(Notification item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.model.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(Notification item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.model.GenericDAO#delete(int)
     */
    @Override
    public void delete(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Notification n = (Notification) session.get(Notification.class, id);
	if (null != n) {
	    session.delete(n);
	}
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.model.GenericDAO#retrieveById(int)
     */
    @Override
    public Notification retrieveById(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Notification n = (Notification) session.get(Notification.class, id);
	return n;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.model.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Notification> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<Notification> notificationsList = session.createQuery("from Notification order by id").list();
	// TODO: Sort by date/priority
	return notificationsList;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.model.GenericDAO#listByProperty(java.lang.String,
     * java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Notification> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(Notification.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<Notification> notificationsList = criteria.list();
	return notificationsList;
    }
}
