package gr.ictpro.mall.model.hibernate;

// Generated Aug 31, 2015 8:17:23 PM by Hibernate Tools 4.0.0

import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Notification generated by hbm2java
 */
@Entity
@Table(name = "notification")
public class Notification implements java.io.Serializable {

    private Integer id;
    private Date date;
    private String message;
    private String module;
    private byte[] parameters;
    private String subject;
    private Set<RoleNotification> roleNotifications = new HashSet<RoleNotification>(0);
    private Set<UserNotification> userNotifications = new HashSet<UserNotification>(0);

    public Notification() {
    }

    public Notification(String message) {
	this.message = message;
    }

    public Notification(Date date, String message, String module, byte[] parameters, String subject,
	    Set<RoleNotification> roleNotifications, Set<UserNotification> userNotifications) {
	this.date = date;
	this.message = message;
	this.module = module;
	this.parameters = parameters;
	this.subject = subject;
	this.roleNotifications = roleNotifications;
	this.userNotifications = userNotifications;
    }

    @Id
    @GeneratedValue(strategy = IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    public Integer getId() {
	return this.id;
    }

    public void setId(Integer id) {
	this.id = id;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date", length = 19)
    public Date getDate() {
	return this.date;
    }

    public void setDate(Date date) {
	this.date = date;
    }

    @Column(name = "message", nullable = false, length = 65535)
    public String getMessage() {
	return this.message;
    }

    public void setMessage(String message) {
	this.message = message;
    }

    @Column(name = "module", length = 50)
    public String getModule() {
	return this.module;
    }

    public void setModule(String module) {
	this.module = module;
    }

    @Column(name = "parameters")
    public byte[] getParameters() {
	return this.parameters;
    }

    public void setParameters(byte[] parameters) {
	this.parameters = parameters;
    }

    @Column(name = "subject", length = 100)
    public String getSubject() {
	return this.subject;
    }

    public void setSubject(String subject) {
	this.subject = subject;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "notification")
    public Set<RoleNotification> getRoleNotifications() {
	return this.roleNotifications;
    }

    public void setRoleNotifications(Set<RoleNotification> roleNotifications) {
	this.roleNotifications = roleNotifications;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "notification")
    public Set<UserNotification> getUserNotifications() {
	return this.userNotifications;
    }

    public void setUserNotifications(Set<UserNotification> userNotifications) {
	this.userNotifications = userNotifications;
    }

}
