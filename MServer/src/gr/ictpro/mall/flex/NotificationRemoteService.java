/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.UserNotification;
import gr.ictpro.mall.service.NotificationService;
import gr.ictpro.mall.utils.Serialize;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class NotificationRemoteService {
    @Autowired(required=true)
    private NotificationService notificationService;
    
    public List<Notification> getNotifications() {
	User currentUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	List<Notification> res =notificationService.retrieveByUser(currentUser);
	return res;
    }
    
    public void handleNotification(ASObject obj) {
	User currentUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	int id = (int) obj.get("id");
	Notification n = notificationService.retrieveById(id);
	for(UserNotification un: n.getUserNotifications()) {
	    if(un.getUser().equals(currentUser)) {
		un.setSeen(GregorianCalendar.getInstance().getTime());
		un.setDone(true);
		notificationService.updateUserNotification(un);
	    }
	}
	for (RoleNotification rn: n.getRoleNotifications()) {
	    if(currentUser.hasRole(rn.getRole().getRole())) {
		rn.setDateHandled(GregorianCalendar.getInstance().getTime());
		rn.setUser(currentUser);
		notificationService.updateRoleNotification(rn);
	    }
	}
	System.err.println(n);
    }
}
