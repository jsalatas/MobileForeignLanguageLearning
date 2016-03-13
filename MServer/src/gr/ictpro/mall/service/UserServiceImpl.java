/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.utils.Serialize;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Service
public class UserServiceImpl extends GenericServiceImpl<User, Integer> implements UserService {
    @Autowired(required=true)
    private GenericService<Role, Integer> roleService;

    @Autowired(required=true)
    private NotificationService notificationService;

    @Autowired(required=true)
    private MailService mailService;


    @Transactional
    @Override
    public void create(User item) {
	create(item, null);
    }

    @Transactional
    @Override
    public void create(User item, User informUser) {
	super.create(item);
	if(item.hasRole("Teacher")) {
	    notificationService.createUserNotification(new Notification("Please setup your classes.", "gr.ictpro.mall.client.view.ClassroomsView", "Classes Setup", true, true), item);
	    Notification n = new Notification("A new teacher has registered. Please review " +(item.isEnabled()?"":"and enable") + " her account.", "gr.ictpro.mall.client.view.UserView", "New Teacher", true, !item.isEnabled());
	    Map<String, Integer> parameters = new LinkedHashMap<String, Integer>();
	    parameters.put("user_id", item.getId());
	    n.setParameters(Serialize.serialize(parameters));
	    notificationService.createRoleNotification(n, roleService.listByProperty("role", "Admin").get(0));
	} else if(item.hasRole("Student")) {
	    Notification n = new Notification("A new student has registered. Please review " +(item.isEnabled()?"":"and enable") + " her account.", "gr.ictpro.mall.client.view.UserView", "New Student", true, !item.isEnabled());
	    Map<String, Integer> parameters = new LinkedHashMap<String, Integer>();
	    parameters.put("user_id", item.getId());
	    n.setParameters(Serialize.serialize(parameters));
	    if(informUser == null) {
		notificationService.createRoleNotification(n, roleService.listByProperty("role", "Teacher").get(0));
	    } else {
		notificationService.createUserNotification(n, informUser);
	    }
	} else if(item.hasRole("Parent")) {
	    Notification n = new Notification("A new parent has registered. Please review " +(item.isEnabled()?"":"and enable") + " her account.", "gr.ictpro.mall.client.view.UserView", "New Parent", true, !item.isEnabled());
	    Map<String, Integer> parameters = new LinkedHashMap<String, Integer>();
	    parameters.put("user_id", item.getId());
	    n.setParameters(Serialize.serialize(parameters));
	    if(informUser == null) {
		notificationService.createRoleNotification(n, roleService.listByProperty("role", "Teacher").get(0));
	    } else {
		notificationService.createUserNotification(n, informUser);
	    }
	}

    }
    
    @Transactional
    @Override
    public List<User> getUserByRole(String role) {
	return getUserByRole(roleService.listByProperty("role", role).get(0));
    }

    @Transactional
    @Override
    public List<User> getUserByRole(Role role) {
	List<User> res = new ArrayList<User>();

	for (User u : role.getUsers()) {
	    res.add(u);
	}

	return res;
    }

    @Transactional
    @Override
    public void updateNotifyUser(User item, boolean notifyEnabled) {
	update(item);
	if(notifyEnabled) {
	    mailService.accountEnabledMail(item);
	}
    }
}
