/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.ArrayList;
import java.util.List;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.authentication.RegistrationMethod;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.User;
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
    protected PasswordEncoder passwordEncoder;

    @Autowired(required = true)
    private UserContext userContext;

    public boolean register(ASObject registrationDetails) {
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	RegistrationMethod reg = (RegistrationMethod) ctx.getBean((String) registrationDetails.get("registrationMethod"));
	return reg.register(registrationDetails);
    }

    public User save(User user) {
	User currentUser = userContext.getCurrentUser();

	if (user.getId() == 0) {
	    userService.create(user);
	} else {
	    // Only Admins and Teacher can modify other users' profiles
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
		persistentUser.getProfile().setColor(user.getProfile().getColor());
		persistentUser.getProfile().setName(user.getProfile().getName());
		persistentUser.getProfile().setPhoto(user.getProfile().getPhoto());

		// user.getProfile().setUserId(user.getId());
		if (sendAccountReadyNotification) {
		    userService.updateNotifyUser(persistentUser, sendAccountReadyNotification);
		} else {
		    userService.update(persistentUser);
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
	} else{
	    // TODO:
	    // for students get their teachers, their parents and other students
	    // in their classroom groups
	    // for parents get their children and their children's teachers
	}

	if (res == null) {
	    res = new ArrayList<User>();
	}

	return res;
    }
}
