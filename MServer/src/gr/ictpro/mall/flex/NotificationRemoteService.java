/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.GregorianCalendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.UserNotification;
import gr.ictpro.mall.service.NotificationService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class NotificationRemoteService {
    @Autowired(required=true)
    private NotificationService notificationService;
    
    @Autowired(required = true)
    private UserContext userContext;

    public List<Notification> getNotifications() {
	User currentUser = userContext.getCurrentUser();
	List<Notification> res =notificationService.retrieveByUser(currentUser);
//	for(Notification n:res) {
//	    Hibernate.initialize(n.getRoleNotifications());
//	    Hibernate.initialize(n.getUserNotifications());
//	}
	return res;
    }
    
    public void updateNotification(Notification n) {
	User currentUser = userContext.getCurrentUser();
	n = notificationService.retrieveById(n.getId());
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
    }
}
