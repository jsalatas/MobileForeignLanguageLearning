package gr.ictpro.mall.model;

// Generated Sep 5, 2014 11:12:49 PM by Hibernate Tools 4.0.0


import gr.ictpro.mall.interceptors.ClientReferenceClass;
import gr.ictpro.mall.model.Classroom;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import org.springframework.flex.core.io.AmfIgnore;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

/**
 * User generated by hbm2java
 */
@Entity
@Table(name = "user", uniqueConstraints = {
	@UniqueConstraint(columnNames = "username"),
	@UniqueConstraint(columnNames = "email") })
@ClientReferenceClass(className="gr.ictpro.mall.client.model.vo.User")
public class User implements java.io.Serializable, UserDetails {
    /**
     * 
     */
    private static final long serialVersionUID = -1552192962451182653L;
    
    private Integer id;
    private String username;
    private String password;
    private String email;
    private boolean enabled;
    private Profile profile;
    private Classroom currentClassroom;
    private Set<Classroom> classrooms = new HashSet<Classroom>(0);
    private Set<Calendar> calendars = new HashSet<Calendar>(0);
    private Set<Schedule> schedules = new HashSet<Schedule>(0);
    private Set<Classroom> teacherClassrooms = new HashSet<Classroom>(0);
    private Set<UserNotification> userNotifications = new HashSet<UserNotification>(0);
    private Set<RoleNotification> roleNotifications = new HashSet<RoleNotification>(0);
    private Set<Role> roles = new HashSet<Role>(0);
    private Set<Location> locations = new HashSet<Location>(0);


    public User() {
    }

    public User(String username, String password, String email, boolean enabled) {
	this.username = username;
	this.password = password;
	this.email = email;
	this.enabled = enabled;
    }

    public User(String username, String password, String email, boolean enabled, Profile profile,
	    Set<Classroom> classrooms, Set<UserNotification> userNotifications,
	    Set<RoleNotification> roleNotifications, Set<Role> roles, Set<Calendar> calendars, 
	    Set<Schedule> schedules, Set<Classroom> teacherClassrooms, Set<Location> locations ) {
	this.username = username;
	this.password = password;
	this.email = email;
	this.enabled = enabled;
	this.profile = profile;
	this.classrooms = classrooms;
	this.userNotifications = userNotifications;
	this.roleNotifications = roleNotifications;
	this.roles = roles;
	this.calendars = calendars;
	this.teacherClassrooms = teacherClassrooms;
	this.schedules = schedules;
	this.locations = locations;
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

    @Column(name = "username", unique = true, nullable = false, length = 20)
    public String getUsername() {
	return this.username;
    }

    public void setUsername(String username) {
	this.username = username;
    }

    @Column(name = "password", nullable = false, length = 60)
    @AmfIgnore
    public String getPassword() {
	return this.password;
    }

    public void setPassword(String password) {
	this.password = password;
    }

    @Column(name = "email", unique = true, nullable = false, length = 45)
    public String getEmail() {
	return this.email;
    }

    public void setEmail(String email) {
	this.email = email;
    }

    @Column(name = "enabled", nullable = false)
    public boolean isEnabled() {
	return this.enabled;
    }

    public void setEnabled(boolean enabled) {
	this.enabled = enabled;
    }

    @OneToOne(fetch = FetchType.EAGER, mappedBy = "user")
    public Profile getProfile() {
	return this.profile;
    }

    public void setProfile(Profile profile) {
	this.profile = profile;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    @AmfIgnore
    public Set<UserNotification> getUserNotifications() {
	return this.userNotifications;
    }

    @AmfIgnore
    public void setUserNotifications(Set<UserNotification> userNotifications) {
	this.userNotifications = userNotifications;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    @AmfIgnore
    public Set<RoleNotification> getRoleNotifications() {
	return this.roleNotifications;
    }

    @AmfIgnore
    public void setRoleNotifications(Set<RoleNotification> roleNotifications) {
	this.roleNotifications = roleNotifications;
    }

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "user_role", joinColumns = {
	    @JoinColumn(name = "user_id", nullable = false, updatable = false) }, inverseJoinColumns = {
	    @JoinColumn(name = "role_id", nullable = false, updatable = false) })
    @OrderBy("id")
    public Set<Role> getRoles() {
	return this.roles;
    }

    public void setRoles(Set<Role> roles) {
	this.roles = roles;
    }

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "classroom_user", joinColumns = {
	    @JoinColumn(name = "user_id", nullable = false, updatable = false) }, inverseJoinColumns = {
	    @JoinColumn(name = "class_id", nullable = false, updatable = false) })
    public Set<Classroom> getClassrooms() {
	return this.classrooms;
    }

    public void setClassrooms(Set<Classroom> classrooms) {
	this.classrooms = classrooms;
    }

    @Override
    public int hashCode() {
	final int prime = 31;
	int result = 1;
	result = prime * result + ((id == null) ? 0 : id.hashCode());
	return result;
    }

    @Override
    public boolean equals(Object obj) {
	if (this == obj)
	    return true;
	if (obj == null)
	    return false;
	if (getClass() != obj.getClass())
	    return false;
	User other = (User) obj;
	if (id == null) {
	    if (other.id != null)
		return false;
	} else if (!id.equals(other.id))
	    return false;
	return true;
    }

    @Override
    public String toString() {
	return username + " <" + email + ">";
    }

    @Override
    @Transient
    @AmfIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
	return this.roles;
    }

    @Transient
    public Classroom getCurrentClassroom() {
	return this.currentClassroom;
    }

    @Transient
    public void setCurrentClassroom(Classroom currentClassroom) {
	this.currentClassroom = currentClassroom;
    }
    
    @Override
    @Transient
    @AmfIgnore
    public boolean isAccountNonExpired() {
	return true;
    }

    @Override
    @Transient
    @AmfIgnore
    public boolean isAccountNonLocked() {
	return this.enabled;
    }

    @Override
    @Transient
    @AmfIgnore
    public boolean isCredentialsNonExpired() {
	return true;
    }

    @Transient
    public boolean hasRole(String role) {
	for (Role r : roles) {
	    if (r.getRole().equals(role)) {
		return true;
	    }
	}

	return false;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    @AmfIgnore
    public Set<Calendar> getCalendars() {
	return this.calendars;
    }

    public void setCalendars(Set<Calendar> calendars) {
	this.calendars = calendars;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    @AmfIgnore
    public Set<Schedule> getSchedules() {
	return this.schedules;
    }

    public void setSchedules(Set<Schedule> schedules) {
	this.schedules = schedules;
    }


    @OneToMany(fetch = FetchType.EAGER, mappedBy = "teacher")
    public Set<Classroom> getTeacherClassrooms() {
	return this.teacherClassrooms;
    }

    public void setTeacherClassrooms(Set<Classroom> teacherClassrooms) {
	this.teacherClassrooms = teacherClassrooms;
    }

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "location_user", joinColumns = {
	    @JoinColumn(name = "user_id", nullable = false, updatable = false) }, inverseJoinColumns = {
	    @JoinColumn(name = "location_id", nullable = false, updatable = false) })
    @AmfIgnore
    public Set<Location> getLocations() {
	return this.locations;
    }

    public void setLocations(Set<Location> locations) {
	this.locations = locations;
    }


}
