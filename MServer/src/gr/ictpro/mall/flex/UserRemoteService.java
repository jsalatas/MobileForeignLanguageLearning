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
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

import org.hibernate.Hibernate;
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
    private GenericService<Role, Integer> roleService;
    
    @Autowired(required = true)
    private GenericService<Profile, Integer>  profileService;
    
    @Autowired(required = true)
    protected PasswordEncoder passwordEncoder;
    
    @Autowired(required = true)
    private UserContext userContext;

    public boolean register(ASObject registrationDetails) {
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	RegistrationMethod reg = (RegistrationMethod) ctx.getBean((String) registrationDetails
		.get("registrationMethod"));
	return reg.register(registrationDetails);
    }

    public User save(ASObject userObject) {
	User currentUser = userContext.getCurrentUser();

	int id = (Integer) userObject.get("id");
	String email = (String) userObject.get("email");
	String name = (String) userObject.get("name");
	byte[] photo = (byte[]) userObject.get("photo");
	int color = (int) userObject.get("color");
	boolean enabled = userObject.get("enabled") != null? (boolean)userObject.get("enabled"):false;
	boolean sendAccountReadyNotification = false;
	
	Set<Role> roles = new HashSet<Role>();
	@SuppressWarnings("unchecked")
	ArrayList<String> r = (ArrayList<String>) userObject.get("roles");
	for (String role : r) {
	    roles.add(roleService.listByProperty("role", role).get(0));
	}
	User u = null;
	try {
	    if (id == -1) {
		String username = (String) userObject.get("username");
		String password = passwordEncoder.encode((String) userObject.get("password"));
		u = new User(username, password, email, enabled);
		u.setRoles(roles);
		userService.create(u);
		Profile p = new Profile(u, name);
		p.setPhoto(photo);
		p.setColor(color);
		profileService.create(p);
		u.setProfile(p);

	    } else {
		// Only Admins and Teacher can modify other users' profiles
		if (id == currentUser.getId() || currentUser.hasRole("Admin") || currentUser.hasRole("Teacher")) {
		    u = userService.retrieveById(id);
		    u.setEmail(email);
		    if(!u.isEnabled() && enabled) {
			sendAccountReadyNotification = true;
		    }
		    u.setEnabled(enabled);
		    Profile p = u.getProfile();
		    if(p == null) {
			// This is the case of admin
			p = new Profile(u, name);
			u.setProfile(p);
			p.setPhoto(photo);
			p.setColor(color);
			profileService.create(p);
		    } else { 
			p.setName(name);
			p.setPhoto(photo);
			p.setColor(color);
			profileService.update(p);
		    }
		    if(userObject.containsKey("password") && userObject.get("password") != null) {
			u.setPassword(passwordEncoder.encode((String) userObject.get("password")));
		    }
		    if(sendAccountReadyNotification) {
			userService.updateNotifyUser(u, sendAccountReadyNotification);
		    } else {
			userService.update(u);
		    }
		}
	    }
	} catch (Exception e) {
	    e.printStackTrace();
	    u = currentUser;
	}
	return u;

    }
    
    public User getUser(ASObject userObject) {
	int id = (Integer) userObject.get("id");
	
	if(id == 1) {
	    // admin
	    return null;
	}
	
	User u = userService.retrieveById(id);
	
	return u;
    }
    
    public List<User> getUsers(ASObject parameters) {
	List<User> res = null;
	if(parameters.containsKey("role")) {
	    List<Role> roles = roleService.listByProperty("role", parameters.get("role"));
	    if(roles.size() == 1) {
		// Should have only one result
		Role r = roles.get(0);
		Hibernate.initialize(r.getUsers());
		res = new ArrayList<User>(r.getUsers());
	    }
	    
	}
	
	if(res == null) {
	    res = new ArrayList<User>();
	}
	
	return res;
    }
}
