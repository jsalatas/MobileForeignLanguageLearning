/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.RoleNotificationId;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class RoleNotificationDAOImpl implements RoleNotificationDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }


    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(RoleNotification item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(RoleNotification item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#delete(java.lang.Object)
     */
    @Override
    public void delete(RoleNotificationId id) {
	Session session = this.sessionFactory.getCurrentSession();
	RoleNotification rn = (RoleNotification) session.load(RoleNotification.class, id);
	if (null != rn) {
	    session.delete(rn);
	}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#retrieveById(java.lang.Object)
     */
    @Override
    public RoleNotification retrieveById(RoleNotificationId id) {
	Session session = this.sessionFactory.getCurrentSession();
	RoleNotification rn = (RoleNotification) session.load(RoleNotification.class, id);
	return rn;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listAll()
     */
    @Override
    public List<RoleNotification> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<RoleNotification> roleNotificationList = session.createQuery("from RoleNotification order by id").list();
	return roleNotificationList;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @Override
    public List<RoleNotification> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(RoleNotification.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<RoleNotification> roleNotificationList = criteria.list();
	return roleNotificationList;
    }

}
