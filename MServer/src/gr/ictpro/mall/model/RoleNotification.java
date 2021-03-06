package gr.ictpro.mall.model;

// Generated Aug 31, 2015 8:07:08 PM by Hibernate Tools 4.0.0

import gr.ictpro.mall.interceptors.ClientReferenceClass;

import java.util.Date;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * RoleNotification generated by hbm2java
 */
@Entity
@Table(name = "role_notification")
@ClientReferenceClass(className="gr.ictpro.mall.client.model.vo.Notification")
public class RoleNotification implements java.io.Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = 7959155028228488149L;
    
    private RoleNotificationId id;
    private Notification notification;
    private Role role;
    private User user;
    private Date dateHandled;

    public RoleNotification() {
    }

    public RoleNotification(RoleNotificationId id, Notification notification, Role role) {
	this.id = id;
	this.notification = notification;
	this.role = role;
    }

    public RoleNotification(RoleNotificationId id, Notification notification, Role role, User user, Date dateHandled) {
	this.id = id;
	this.notification = notification;
	this.role = role;
	this.user = user;
	this.dateHandled = dateHandled;
    }

    @EmbeddedId
    @AttributeOverrides({
	    @AttributeOverride(name = "roleId", column = @Column(name = "role_id", nullable = false)),
	    @AttributeOverride(name = "notificationId", column = @Column(name = "notification_id", nullable = false)) })
    public RoleNotificationId getId() {
	return this.id;
    }

    public void setId(RoleNotificationId id) {
	this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "notification_id", nullable = false, insertable = false, updatable = false)
    public Notification getNotification() {
	return this.notification;
    }

    public void setNotification(Notification notification) {
	this.notification = notification;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id", nullable = false, insertable = false, updatable = false)
    public Role getRole() {
	return this.role;
    }

    public void setRole(Role role) {
	this.role = role;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "handled_by")
    public User getUser() {
	return this.user;
    }

    public void setUser(User user) {
	this.user = user;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_handled", length = 19)
    public Date getDateHandled() {
	return this.dateHandled;
    }

    public void setDateHandled(Date dateHandled) {
	this.dateHandled = dateHandled;
    }

}
