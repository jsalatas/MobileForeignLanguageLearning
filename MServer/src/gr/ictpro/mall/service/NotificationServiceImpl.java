/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.GenericDAO;
import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.RoleNotificationId;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.UserNotification;
import gr.ictpro.mall.model.UserNotificationId;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Service
public class NotificationServiceImpl  extends GenericServiceImpl<Notification, Integer> implements NotificationService {
    @Autowired(required=true)
    private GenericDAO<UserNotification, UserNotificationId> userNotificationDAO;
    
    @Autowired(required=true)
    private GenericDAO<RoleNotification, RoleNotificationId> roleNotificationDAO;

    @Transactional
    @Override
    public void createUserNotification(Notification n, User u) {
	getDao().create(n);
	UserNotificationId unid = new UserNotificationId(u.getId(), n.getId());
	UserNotification un = new UserNotification(unid, u, n, false);
	userNotificationDAO.create(un);
	List<User> userList = new ArrayList<User>();
	userList.add(u);
    }

    @Transactional
    private void createUserNotificationNoMessaging(Notification n, User u) {
	getDao().create(n);
	UserNotificationId unid = new UserNotificationId(u.getId(), n.getId());
	UserNotification un = new UserNotification(unid, u, n, false);
	userNotificationDAO.create(un);
    }

    @Transactional
    @Override
    public void createUserNotification(Notification n, List<User> u) {
	for (User user : u) {
	    createUserNotificationNoMessaging(n, user);
	}
    }

    @Transactional
    @Override
    public void createUserNotification(Notification n, Role r) {
	
	for (User u : r.getUsers()) {
	    createUserNotificationNoMessaging(n, u);
	}
	List<Role> roleList = new ArrayList<Role>();
	roleList.add(r);

    }

    @Transactional
    @Override
    public void createRoleNotification(Notification n, Role r) {
	getDao().create(n);
	RoleNotificationId rnid = new RoleNotificationId(r.getId(), n.getId());
	RoleNotification rn = new RoleNotification(rnid, n, r);
	roleNotificationDAO.create(rn);
	List<Role> roleList = new ArrayList<Role>();
	roleList.add(r);
    }

    @Transactional
    @Override
    public void updateRoleNotification(RoleNotification n) {
	roleNotificationDAO.update(n);
	List<Role> roleList = new ArrayList<Role>();
	roleList.add(n.getRole());
    }

    @Transactional
    @Override
    public void updateUserNotification(UserNotification n) {
	userNotificationDAO.update(n);
	List<User> userList = new ArrayList<User>();
	userList.add(n.getUser());
    }

    @Transactional
    @Override
    public void deleteRoleNotification(Notification n, Role r) {
	RoleNotification rn = roleNotificationDAO.retrieveById(new RoleNotificationId(r.getId(), n.getId()));
	roleNotificationDAO.delete(rn);
	List<Role> roleList = new ArrayList<Role>();
	roleList.add(r);
    }

    @Transactional
    @Override
    public void deleteUserNotification(Notification n, User u) {
	UserNotification un = userNotificationDAO.retrieveById(new UserNotificationId(u.getId(), n.getId()));
	userNotificationDAO.delete(un);
	List<User> userList = new ArrayList<User>();
	userList.add(u);
    }

    @Transactional
    private void deleteUserNotificationNoMessaging(Notification n, User u) {
	UserNotification un = userNotificationDAO.retrieveById(new UserNotificationId(u.getId(), n.getId()));
	userNotificationDAO.delete(un);
    }

    @Transactional
    @Override
    public void deleteUserNotification(Notification n, List<User> u) {
	for (User user : u) {
	    deleteUserNotificationNoMessaging(n, user);
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
