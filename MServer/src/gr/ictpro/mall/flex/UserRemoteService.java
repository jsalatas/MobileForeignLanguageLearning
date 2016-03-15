/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.authentication.RegistrationMethod;
import gr.ictpro.mall.context.LocationContext;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Classroomgroup;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.context.ContextLoader;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class UserRemoteService {
    @Autowired(required = true)
    private UserService userService;

    @Autowired(required = true)
    protected GenericService<Profile, Integer> profileService;
    

    @Autowired(required = true)
    protected PasswordEncoder passwordEncoder;

    @Autowired(required = true)
    private UserContext userContext;

    @Autowired(required = true)
    private LocationContext locationContext;

    public boolean register(ASObject registrationDetails) {
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	RegistrationMethod reg = (RegistrationMethod) ctx.getBean((String) registrationDetails.get("registrationMethod"));
	return reg.register(registrationDetails);
    }

    public void deleteUser(User user) {
	User currentUser = userContext.getCurrentUser();
	User persistentUser = userService.retrieveById(user.getId());
	if(currentUser.hasRole("Admin")) {
	    userContext.removeFromConnectedUsers(persistentUser);
	    profileService.delete(persistentUser.getProfile());
	    userService.delete(persistentUser);
	} else if(currentUser.hasRole("Teacher") && (persistentUser.hasRole("Student") || persistentUser.hasRole("Parent"))) {
	    userContext.removeFromConnectedUsers(persistentUser);
	    profileService.delete(persistentUser.getProfile());
	    userService.delete(persistentUser);
	}
    }
    
    public User save(User user) {
	User currentUser = userContext.getCurrentUser();
	
	if (user.getId() == 0) {
	    userService.create(user);
	} else {
	    // Admins and Teacher can modify other users' profiles
	    // Parents can only change their children's allowance in unattended meetings
	    if (user.getId() == currentUser.getId() || currentUser.hasRole("Admin") || currentUser.hasRole("Teacher")) {
		User persistentUser = userService.retrieveById(user.getId());
		boolean sendAccountReadyNotification = !persistentUser.isEnabled() && user.isEnabled();

		if (user.getPassword() != null) {
		    // encrypt it
		    persistentUser.setPassword(passwordEncoder.encode((String) user.getPassword()));
		}
		persistentUser.setEmail(user.getEmail());
		persistentUser.setEnabled(user.isEnabled());
		persistentUser.setRoles(user.getRoles());
		persistentUser.setClassrooms(user.getClassrooms());
		persistentUser.setUsername(user.getUsername());
		persistentUser.setParents(user.getParents());
		persistentUser.setChildren(user.getChildren());
		persistentUser.setDisallowUnattendedMeetings(user.isDisallowUnattendedMeetings());
		persistentUser.getProfile().setColor(user.getProfile().getColor());
		persistentUser.getProfile().setName(user.getProfile().getName());
		persistentUser.getProfile().setPhoto(user.getProfile().getPhoto());
		persistentUser.getProfile().setLanguage(user.getProfile().getLanguage());

		// user.getProfile().setUserId(user.getId());
		if (sendAccountReadyNotification) {
		    userService.updateNotifyUser(persistentUser, sendAccountReadyNotification);
		} else {
		    userService.update(persistentUser);
		}
		user = persistentUser;
	    } else if (currentUser.hasRole("Parent")) {
		for(User persistentUser: currentUser.getChildren()) {
		    if(persistentUser.getId().intValue() == user.getId().intValue()) {
			persistentUser.setDisallowUnattendedMeetings(user.isDisallowUnattendedMeetings());
			userService.update(persistentUser);
			break;
		    }
		}
	    }
	}

	return user;
    }

    public User getUser(ASObject userObject) {
	int id = (Integer) userObject.get("id");

	if (id == 1) {
	    // admin
	    return null;
	}

	User u = userService.retrieveById(id);

	return u;
    }

    public List<User> getOnlineUsers() {
	List<User> allUsers = getUsers();
	List<User> res = new ArrayList<User>();
	
	for(User u: allUsers) {
	    if(u.isAvailable() && userContext.userIsOnline(u)) {
		res.add(u);
	    }
	}
	
	return res;
    }
    
    
    public List<User> getUsers() {
	List<User> res = null;
	User currentUser = userContext.getCurrentUser();
	if (currentUser.hasRole("Admin")) {
	    res = userService.listAll();
	} else if(currentUser.hasRole("Teacher")){
	    // Get teacher's students
	    res = new ArrayList<User>();
	    for(Classroom classroom: currentUser.getTeacherClassrooms()) {
		res.addAll(classroom.getStudents());
	    }
	    // Get unassigned students
	    String hql = "SELECT u FROM User u JOIN u.roles r WHERE r.role = 'Student' AND u.classrooms IS EMPTY"; 
	    res.addAll(userService.listByCustomSQL(hql));
	} else if(currentUser.hasRole("Student")){
	    Set<User> uniqueUsers = new HashSet<User>(); 
	    for(Classroom classroom: currentUser.getClassrooms()) {
		if(classroom.getClassroomgroups().size() == 0) {
		    uniqueUsers.addAll(classroom.getStudents());
		    uniqueUsers.add(classroom.getTeacher());
		} else {
		    for(Classroomgroup group: classroom.getClassroomgroups()) {
			for(Classroom classroomInGroup: group.getClassrooms()) {
			    uniqueUsers.addAll(classroomInGroup.getStudents());
			    uniqueUsers.add(classroomInGroup.getTeacher());
			}
		    }
		}
	    }
	    res = new ArrayList<User>();
	    res.addAll(uniqueUsers);
	} else if(currentUser.hasRole("Parent")){
	    Set<User> uniqueUsers = new HashSet<User>(); 
	    for(User u: currentUser.getChildren()) {
		uniqueUsers.add(u);
		for(Classroom c: u.getClassrooms()) {
		    uniqueUsers.add(c.getTeacher());
		}
	    }
	    
	    res = new ArrayList<User>();
	    res.addAll(uniqueUsers);

	}

	if (res == null) {
	    res = new ArrayList<User>();
	}

	return res;
    }

    public void updateCurrentClassroom(Classroom classroom) {
	userContext.getCurrentUser().setCurrentClassroom(classroom);
    }
    
    public void updateLocation(ASObject currentLocationObj) {
	User currentUser = userContext.getCurrentUser();
	currentUser.setCurrentLocation(locationContext.parseLocationTags(currentLocationObj));
    }
    
    public void switchAvailability() {
	User currentUser = userContext.getCurrentUser();
	currentUser.setAvailable(!currentUser.isAvailable());
	userService.update(currentUser);
    }
}
