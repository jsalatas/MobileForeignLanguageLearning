/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.NotificationService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class NotificationRemoteService {
    private NotificationService notificationService;
    
    public void setNotificationService(NotificationService notificationService) {
	this.notificationService = notificationService;
    }

    public List<Notification> getNotifications() {
	User currentUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	List<Notification> res =notificationService.retrieveByUser(currentUser);

	return res;
    }
}
