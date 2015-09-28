/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.UserNotification;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface NotificationService extends GenericService<Notification, Integer> {
    public void createUserNotification(Notification n, User u);
    public void createUserNotification(Notification n, List<User> u);
    public void createUserNotification(Notification n, Role r);
    public void createRoleNotification(Notification n, Role r);
    public void updateRoleNotification(RoleNotification n);
    public void updateUserNotification(UserNotification n);
    public void deleteRoleNotification(Notification n, Role r);
    public void deleteUserNotification(Notification n, User u);
    public void deleteUserNotification(Notification n, List<User> u);
    public List<Notification> retrieveByUser(User u);

}
