/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.NotificationDAO;
import gr.ictpro.mall.dao.RoleNotificationDAO;
import gr.ictpro.mall.dao.UserNotificationDAO;
import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.RoleNotificationId;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.UserNotification;
import gr.ictpro.mall.model.UserNotificationId;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Hibernate;
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

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(Notification item) {
	notificationDAO.create(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(Notification item) {
	notificationDAO.update(item);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#delete(int)
     */
    @Transactional
    @Override
    public void delete(Integer id) {
	notificationDAO.delete(id);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#retrieveById(int)
     */
    @Transactional
    @Override
    public Notification retrieveById(Integer id) {
	return notificationDAO.retrieveById(id);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<Notification> listAll() {
	return notificationDAO.listAll();
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * gr.ictpro.mall.service.GenericService#listByProperty(java.lang.String,
     * java.lang.Object)
     */
    @Transactional
    @Override
    public List<Notification> listByProperty(String propertyName, Object propertyValue) {
	return notificationDAO.listByProperty(propertyName, propertyValue);
    }

    @Transactional
    @Override
    public void createUserNotification(Notification n, User u) {
	notificationDAO.create(n);
	UserNotificationId unid = new UserNotificationId(u.getId(), n.getId());
	UserNotification un = new UserNotification(unid, u, n, false);
	userNotificationDAO.create(un);
    }

    @Transactional
    @Override
    public void createUserNotification(Notification n, List<User> u) {
	for (User user : u) {
	    createUserNotification(n, user);
	}
    }

    @Transactional
    @Override
    public void createUserNotification(Notification n, Role r) {
	for (User u : r.getUsers()) {
	    createUserNotification(n, u);
	}
    }

    @Transactional
    @Override
    public void createRoleNotification(Notification n, Role r) {
	notificationDAO.create(n);
	RoleNotificationId rnid = new RoleNotificationId(r.getId(), n.getId());
	RoleNotification rn = new RoleNotification(rnid, n, r);
	roleNotificationDAO.create(rn);
    }

    @Transactional
    @Override
    public void updateRoleNotification(RoleNotification n) {
	roleNotificationDAO.update(n);
    }

    @Transactional
    @Override
    public void updateUserNotification(UserNotification n) {
	userNotificationDAO.update(n);
    }

    @Transactional
    @Override
    public void deleteRoleNotification(Notification n, Role r) {
	RoleNotificationId rnid = new RoleNotificationId(r.getId(), n.getId());
	roleNotificationDAO.delete(rnid);
    }

    @Transactional
    @Override
    public void deleteUserNotification(Notification n, User u) {
	UserNotificationId unid = new UserNotificationId(u.getId(), n.getId());
	userNotificationDAO.delete(unid);
    }

    @Transactional
    @Override
    public void deleteUserNotification(Notification n, List<User> u) {
	for (User user : u) {
	    deleteUserNotification(n, user);
	}
    }

    @Transactional
    @Override
    public List<Notification> retrieveByUser(User u) {
	List<Notification> res = new ArrayList<Notification>();

	List<UserNotification> unList = userNotificationDAO.listByProperty("id.userId", u.getId());
	if (unList != null) {
	    for (UserNotification un : unList) {
		if(!un.getDone()) {
		    res.add(un.getNotification());
		}
	    }
	}

	for (Role r : u.getRoles()) {
	    List<RoleNotification> rnList = roleNotificationDAO.listByProperty("id.roleId", r.getId());
	    if (rnList != null) {
		for (RoleNotification rn : rnList) {
		    if(rn.getDateHandled() == null) {
			res.add(rn.getNotification());
		    }
		}
	    }
	}
	return res;
    }
}
