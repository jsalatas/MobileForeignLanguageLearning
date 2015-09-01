package gr.ictpro.mall.model;

// Generated Aug 31, 2015 8:07:08 PM by Hibernate Tools 4.0.0

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * UserNotificationId generated by hbm2java
 */
@Embeddable
public class UserNotificationId implements java.io.Serializable {

    private int userId;
    private int notificationId;

    public UserNotificationId() {
    }

    public UserNotificationId(int userId, int notificationId) {
	this.userId = userId;
	this.notificationId = notificationId;
    }

    @Column(name = "user_id", nullable = false)
    public int getUserId() {
	return this.userId;
    }

    public void setUserId(int userId) {
	this.userId = userId;
    }

    @Column(name = "notification_id", nullable = false)
    public int getNotificationId() {
	return this.notificationId;
    }

    public void setNotificationId(int notificationId) {
	this.notificationId = notificationId;
    }

    public boolean equals(Object other) {
	if ((this == other))
	    return true;
	if ((other == null))
	    return false;
	if (!(other instanceof UserNotificationId))
	    return false;
	UserNotificationId castOther = (UserNotificationId) other;

	return (this.getUserId() == castOther.getUserId())
		&& (this.getNotificationId() == castOther.getNotificationId());
    }

    public int hashCode() {
	int result = 17;

	result = 37 * result + this.getUserId();
	result = 37 * result + this.getNotificationId();
	return result;
    }

}
