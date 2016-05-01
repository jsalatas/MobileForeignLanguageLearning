package gr.ictpro.mall.model;

// Generated Sep 5, 2014 11:12:49 PM by Hibernate Tools 4.0.0


import gr.ictpro.mall.interceptors.ClientReferenceClass;

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
    private boolean disallowUnattendedMeetings;
    private boolean autoApproveUnattendedMeetings;
    private boolean available;
    private Set<Classroom> classrooms = new HashSet<Classroom>(0);
    private Set<Meeting> approvedMeetings = new HashSet<Meeting>(0);
    private Set<MeetingUser> approvedMeetingUsers = new HashSet<MeetingUser>(0);
    private Set<Meeting> createdMeetings = new HashSet<Meeting>(0);
    private Set<Calendar> calendars = new HashSet<Calendar>(0);
    private Set<Schedule> schedules = new HashSet<Schedule>(0);
    private Set<Classroom> teacherClassrooms = new HashSet<Classroom>(0);
    private Set<UserNotification> userNotifications = new HashSet<UserNotification>(0);
    private Set<RoleNotification> roleNotifications = new HashSet<RoleNotification>(0);
    private Set<Role> roles = new HashSet<Role>(0);
    private Set<Location> locations = new HashSet<Location>(0);
    private Set<WifiTag> currentLocation = new HashSet<WifiTag>(0);
    private Set<MeetingUser> meetingUsers = new HashSet<MeetingUser>(0);
    private Set<User> children = new HashSet<User>(0);
    private Set<User> parents = new HashSet<User>(0);
    private boolean online = false;


    public User() {
    }

    public User(String username, String password, String email, boolean enabled, boolean disallowUnattendedMeetings, boolean autoApproveUnattendedMeetings, boolean available) {
	this.username = username;
	this.password = password;
	this.email = email;
	this.enabled = enabled;
	this.disallowUnattendedMeetings = disallowUnattendedMeetings;
	this.autoApproveUnattendedMeetings = autoApproveUnattendedMeetings;
	this.available = available;
    }

    public User(String username, String password, String email, boolean enabled, Profile profile,
	    Set<Classroom> classrooms, Set<UserNotification> userNotifications, Set<Meeting> approvedMeetings, Set<MeetingUser> approvedMeetingUsers, 
	    Set<RoleNotification> roleNotifications, Set<Role> roles, Set<Calendar> calendars, Set<MeetingUser> meetingUsers, 
	    Set<Schedule> schedules, Set<Classroom> teacherClassrooms, Set<Location> locations, boolean disallowUnattendedMeetings,
	    boolean autoApproveUnattendedMeetings, boolean available, Set<User> children, Set<User> parents, Set<Meeting> createdMeetings) {
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
	this.disallowUnattendedMeetings = disallowUnattendedMeetings;
	this.available = available;
	this.approvedMeetings = approvedMeetings;
	this.approvedMeetingUsers = approvedMeetingUsers;
	this.autoApproveUnattendedMeetings = autoApproveUnattendedMeetings;
	this.meetingUsers = meetingUsers;
	this.parents = parents;
	this.children = children;
	this.createdMeetings = createdMeetings;
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

    @Column(name = "disallow_unattended_meetings", nullable = false)
    public boolean isDisallowUnattendedMeetings() {
	return this.disallowUnattendedMeetings;
    }

    public void setDisallowUnattendedMeetings(boolean disallowUnattendedMeetings) {
	this.disallowUnattendedMeetings = disallowUnattendedMeetings;
    }

    @Column(name = "auto_approve_unattended_meetings", nullable = false)
    public boolean isAutoApproveUnattendedMeetings() {
	return this.autoApproveUnattendedMeetings;
    }

    public void setAutoApproveUnattendedMeetings(boolean autoApproveUnattendedMeetings) {
	this.autoApproveUnattendedMeetings = autoApproveUnattendedMeetings;
    }

    @Column(name = "available", nullable = false)
    public boolean isAvailable() {
	return this.available;
    }

    public void setAvailable(boolean available) {
	this.available = available;
    }

    @AmfIgnore
    @Transient
    public Set<WifiTag> getCurrentLocation() {
	return this.currentLocation;
    }

    @Transient
    public void setCurrentLocation(Set<WifiTag> currentLocation) {
	this.currentLocation = currentLocation;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "approvedBy")
    @AmfIgnore
    public Set<Meeting> getApprovedMeetings() {
	return this.approvedMeetings;
    }

    @AmfIgnore
    public void setApprovedMeetings(Set<Meeting> approvedMeetings) {
	this.approvedMeetings = approvedMeetings;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "approvedBy")
    @AmfIgnore
    public Set<MeetingUser> getApprovedMeetingUsers() {
	return this.approvedMeetingUsers;
    }

    @AmfIgnore
    public void setApprovedMeetingUsers(Set<MeetingUser> approvedMeetingUsers) {
	this.approvedMeetingUsers = approvedMeetingUsers;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    @AmfIgnore
    public Set<MeetingUser> getMeetingUsers() {
	return this.meetingUsers;
    }

    @AmfIgnore
    public void setMeetingUsers(Set<MeetingUser> meetingUsers) {
	this.meetingUsers = meetingUsers;
    }

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "student_parent", joinColumns = {
	    @JoinColumn(name = "parent_id", nullable = false, updatable = false) }, inverseJoinColumns = {
	    @JoinColumn(name = "student_id", nullable = false, updatable = false) })
    public Set<User> getChildren() {
	return this.children;
    }

    public void setChildren(Set<User> children) {
	this.children = children;
    }

	
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "student_parent", joinColumns = {
	    @JoinColumn(name = "student_id", nullable = false, updatable = false) }, inverseJoinColumns = {
	    @JoinColumn(name = "parent_id", nullable = false, updatable = false) })
    public Set<User> getParents() {
	return this.parents;
    }

    public void setParents(Set<User> parents) {
	this.parents = parents;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "createdBy")
    @AmfIgnore
    public Set<Meeting> getCreatedMeetings() {
	return this.createdMeetings;
    }

    @AmfIgnore
    public void setCreatedMeetings(Set<Meeting> createdMeetings) {
	this.createdMeetings = createdMeetings;
    }

    @Transient
    public boolean isOnline() {
        return online;
    }

    @Transient
    public void setOnline(boolean online) {
        this.online = online;
    }

    

}
