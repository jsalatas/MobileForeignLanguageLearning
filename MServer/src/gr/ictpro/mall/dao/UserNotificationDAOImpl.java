/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.UserNotification;
import gr.ictpro.mall.model.UserNotificationId;

import java.util.List;

import org.hibernate.SessionFactory;

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
	// TODO Auto-generated method stub

    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(UserNotification item) {
	// TODO Auto-generated method stub

    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#delete(int)
     */
    @Override
    public void delete(UserNotificationId id) {
	// TODO Auto-generated method stub

    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#retrieveById(int)
     */
    @Override
    public UserNotification retrieveById(UserNotificationId id) {
	// TODO Auto-generated method stub
	return null;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listAll()
     */
    @Override
    public List<UserNotification> listAll() {
	// TODO Auto-generated method stub
	return null;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @Override
    public List<UserNotification> listByProperty(String propertyName, Object propertyValue) {
	// TODO Auto-generated method stub
	return null;
    }

}
