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
 * UserNotification generated by hbm2java
 */
@Entity
@Table(name = "user_notification")
@ClientReferenceClass(className="gr.ictpro.mall.client.model.vo.Notification")
public class UserNotification implements java.io.Serializable {
    /**
     * 
     */
    private static final long serialVersionUID = 8357088135570298679L;
    
    private UserNotificationId id;
    private User user;
    private Notification notification;
    private boolean done;
    private Date seen;

    public UserNotification() {
    }

    public UserNotification(UserNotificationId id, User user, Notification notification, boolean done) {
	this.id = id;
	this.user = user;
	this.notification = notification;
	this.done = done;
    }

    public UserNotification(UserNotificationId id, User user, Notification notification, boolean done, Date seen) {
	this.id = id;
	this.user = user;
	this.notification = notification;
	this.done = done;
	this.seen = seen;
    }

    @EmbeddedId
    @AttributeOverrides({
	    @AttributeOverride(name = "userId", column = @Column(name = "user_id", nullable = false)),
	    @AttributeOverride(name = "notificationId", column = @Column(name = "notification_id", nullable = false)) })
    public UserNotificationId getId() {
	return this.id;
    }

    public void setId(UserNotificationId id) {
	this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false, insertable = false, updatable = false)
    public User getUser() {
	return this.user;
    }

    public void setUser(User user) {
	this.user = user;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "notification_id", nullable = false, insertable = false, updatable = false)
    public Notification getNotification() {
	return this.notification;
    }

    public void setNotification(Notification notification) {
	this.notification = notification;
    }

    @Column(name = "done", nullable = false)
    public boolean getDone() {
	return this.done;
    }

    public void setDone(boolean done) {
	this.done = done;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "seen", length = 19)
    public Date getSeen() {
	return this.seen;
    }

    public void setSeen(Date seen) {
	this.seen = seen;
    }

}
