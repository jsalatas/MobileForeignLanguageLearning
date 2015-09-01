/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.NotificationDAO;
import gr.ictpro.mall.dao.RoleNotificationDAO;
import gr.ictpro.mall.dao.UserNotificationDAO;
import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class NotificationServiceImpl implements NotificationService {
    private NotificationDAO notificationDAO;
    private UserNotificationDAO userNotificationDAO;
    private RoleNotificationDAO roleNotificationDAO;

    public void setNotificationDAO(NotificationDAO notificationDAO) {
	this.notificationDAO = notificationDAO;
    }

    public void setUserNotificationDAO(UserNotificationDAO userNotificationDAO) {
	this.userNotificationDAO = userNotificationDAO;
    }

    public void setRoleNotificationDAO(RoleNotificationDAO roleNotificationDAO) {
	this.roleNotificationDAO = roleNotificationDAO;
    }
    
    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(Notification item) {
	notificationDAO.create(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(Notification item) {
	notificationDAO.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#delete(int)
     */
    @Transactional
    @Override
    public void delete(Integer id) {
	notificationDAO.delete(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#retrieveById(int)
     */
    @Transactional
    @Override
    public Notification retrieveById(Integer id) {
	return notificationDAO.retrieveById(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<Notification> listAll() {
	return notificationDAO.listAll();
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listByProperty(java.lang.String, java.lang.Object)
     */
    @Transactional
    @Override
    public List<Notification> listByProperty(String propertyName, Object propertyValue) {
	return notificationDAO.listByProperty(propertyName, propertyValue);
    }

    @Override
    public void createUserNotification(Notification n, User u) {
	// TODO Auto-generated method stub
	
    }

    @Override
    public void createUserNotification(Notification n, List<User> u) {
	// TODO Auto-generated method stub
	
    }

    @Override
    public void createUserNotification(Notification n, Role r) {
	// TODO Auto-generated method stub
	
    }

    @Override
    public void createRoleNotification(Notification n, Role r) {
	// TODO Auto-generated method stub
	
    }
}
