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
import gr.ictpro.mall.service.ProfileService;
import gr.ictpro.mall.service.RoleService;
import gr.ictpro.mall.service.UserService;

import org.springframework.context.ApplicationContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.ContextLoader;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class UserRemoteService {
    private UserService userService;
    private RoleService roleService;
    private ProfileService profileService;

    public void setUserService(UserService userService) {
	this.userService = userService;
    }

    public void setRoleService(RoleService roleService) {
	this.roleService = roleService;
    }

    public void setProfileService(ProfileService profileService) {
	this.profileService = profileService;
    }

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

	Set<Role> roles = new HashSet<Role>();
	ArrayList<String> r = (ArrayList<String>) userObject.get("roles");
	for (String role : r) {
	    roles.add(roleService.listByProperty("role", role).get(0));
	}
	User u = null;
	try {
	    if (id == -1) {
		String username = (String) userObject.get("username");
		String password = (String) userObject.get("password");
		u = new User(username, password, email, true);
		u.setRoles(roles);
		userService.create(u);
		Profile p = new Profile(u, name);
		p.setPhoto(photo);
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
			p.setPhoto(photo);
			profileService.create(p);
			u.setProfile(p);
		    } else { 
			p.setName(name);
			p.setPhoto(photo);
			profileService.update(p);
		    }
		    userService.update(u);
		}
	    }
	} catch (Exception e) {
	    u = currentUser;
	}
	return u;

    }
}
