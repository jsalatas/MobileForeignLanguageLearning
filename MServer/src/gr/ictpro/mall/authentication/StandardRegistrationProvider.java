/**
 * 
 */
package gr.ictpro.mall.authentication;

import java.util.HashSet;
import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.context.ContextLoader;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.MailService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Component
public class StandardRegistrationProvider extends AbstractRegistrationProvider {

    @Override
    public boolean register(ASObject registrationDetails) {

	String userName = (String) registrationDetails.get("userName");
	String name = (String) registrationDetails.get("name");
	String password = passwordEncoder.encode((String) registrationDetails.get("password"));
	String email = (String) registrationDetails.get("email");
	Integer roleId = (Integer) registrationDetails.get("role");
	String relatedUser = (String) registrationDetails.get("relatedUser");

	User informUser = null;
	if(relatedUser != null) {
	    List<User> users = userService.listByProperty("username", relatedUser);
	    if(users.size() == 1) {
		informUser = users.get(0);
	    }
	}
	
	HashSet<Role> r = new HashSet<Role>(); 
	try {
	    r.add(roleService.retrieveById(roleId.intValue()));
	} catch (Exception e) {
	    e.printStackTrace();
	}                                 
	 
	User u = new User(userName, password, email, false);
	u.setRoles(r);
	userService.create(u, informUser);
	Profile p = new Profile(u, name);
	profileService.create(p);
	u.setProfile(p);
	// inform related users about the registration
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	MailService mail = (MailService) ctx.getBean("mailService");
	mail.registrationMail(u, informUser);
	
	return u.isEnabled();
    }

}
