/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.RoleNotificationId;

import java.util.List;

import org.hibernate.SessionFactory;

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
	// TODO Auto-generated method stub

    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(RoleNotification item) {
	// TODO Auto-generated method stub

    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#delete(java.lang.Object)
     */
    @Override
    public void delete(RoleNotificationId id) {
	// TODO Auto-generated method stub

    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#retrieveById(java.lang.Object)
     */
    @Override
    public RoleNotification retrieveById(RoleNotificationId id) {
	// TODO Auto-generated method stub
	return null;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listAll()
     */
    @Override
    public List<RoleNotification> listAll() {
	// TODO Auto-generated method stub
	return null;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @Override
    public List<RoleNotification> listByProperty(String propertyName, Object propertyValue) {
	// TODO Auto-generated method stub
	return null;
    }

}
