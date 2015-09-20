/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface NotificationService extends GenericService<Notification, Integer> {
    public void createUserNotification(Notification n, User u);
    public void createUserNotification(Notification n, List<User> u);
    public void createUserNotification(Notification n, Role r);
    public void createRoleNotification(Notification n, Role r);
    public void updateRoleNotification(Notification n, Role r, Date dateHandled, User handledBy);
    public void updateUserNotification(Notification n, User u, Boolean done, Date seen);
    public void deleteRoleNotification(Notification n, Role r);
    public void deleteUserNotification(Notification n, User u);
    public void deleteUserNotification(Notification n, List<User> u);
    public List<Notification> retrieveByUser(User u);

}
