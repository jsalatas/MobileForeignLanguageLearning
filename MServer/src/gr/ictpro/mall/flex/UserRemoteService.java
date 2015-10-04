/**
 * 
 */
package gr.ictpro.mall.flex;


import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.authentication.RegistrationMethod;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

    public User register(ASObject registrationDetails) {
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	RegistrationMethod reg = (RegistrationMethod) ctx.getBean((String) registrationDetails
		.get("registrationMethod"));
	return reg.register(registrationDetails);
    }

    public User save(ASObject userObject) {
	User currentUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

	int id = (Integer) userObject.get("id");
	String email = (String) userObject.get("email");
	String name = (String) userObject.get("name");
	byte[] photo = (byte[]) userObject.get("photo");
	int color = (int) userObject.get("color");

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
		u = new User(username, password, email, true);
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
		    userService.update(u);
		}
	    }
	} catch (Exception e) {
	    e.printStackTrace();
	    u = currentUser;
	}
	return u;

    }
}
