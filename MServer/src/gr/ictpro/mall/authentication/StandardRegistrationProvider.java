/**
 * 
 */
package gr.ictpro.mall.authentication;

import java.util.HashSet;

import org.springframework.stereotype.Component;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Component
public class StandardRegistrationProvider extends AbstractRegistrationProvider {

    @Override
    public User register(ASObject registrationDetails) {

	String userName = (String) registrationDetails.get("userName");
	String firstName = (String) registrationDetails.get("firstName");
	String lastName = (String) registrationDetails.get("lastName");
	String password = passwordEncoder.encode((String) registrationDetails.get("password"));
	String email = (String) registrationDetails.get("email");
	Integer roleId = (Integer) registrationDetails.get("role");
	HashSet<Role> r = new HashSet<Role>(); 
	try {
	    r.add(roleService.retrieveById(roleId.intValue()));
	} catch (Exception e) {
	    e.printStackTrace();
	}                                 
	 
	//TODO: check enabled status
	User u = new User(userName, password, email, true);
	u.setRoles(r);
	userService.create(u);
	Profile p = new Profile(u, firstName, lastName);
	profileService.create(p);
	u.setProfile(p);
	return u;
    }

}
