/**
 * 
 */
package gr.ictpro.mall.dao;


import gr.ictpro.mall.model.UserNotification;
import gr.ictpro.mall.model.UserNotificationId;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class UserNotificationDAOImpl implements UserNotificationDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(UserNotification item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(UserNotification item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#delete(int)
     */
    @Override
    public void delete(UserNotificationId id) {
	Session session = this.sessionFactory.getCurrentSession();
	UserNotification un = (UserNotification) session.load(UserNotification.class, id);
	if (null != un) {
	    session.delete(un);
	}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#retrieveById(int)
     */
    @Override
    public UserNotification retrieveById(UserNotificationId id) {
	Session session = this.sessionFactory.getCurrentSession();
	UserNotification un = (UserNotification) session.load(UserNotification.class, id);
	return un;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listAll()
     */
    @Override
    public List<UserNotification> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<UserNotification> userNotificationList = session.createQuery("from UserNotification order by id").list();
	return userNotificationList;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @Override
    public List<UserNotification> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(UserNotification.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<UserNotification> userNotificationList = criteria.list();
	return userNotificationList;
    }

}
