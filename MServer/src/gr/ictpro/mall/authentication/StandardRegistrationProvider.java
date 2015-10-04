/**
 * 
 */
package gr.ictpro.mall.authentication;

import java.util.HashSet;

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
    public User register(ASObject registrationDetails) {

	String userName = (String) registrationDetails.get("userName");
	String name = (String) registrationDetails.get("name");
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
	User u = new User(userName, password, email, false);
	u.setRoles(r);
	userService.create(u);
	Profile p = new Profile(u, name);
	profileService.create(p);
	u.setProfile(p);
	// inform admin about the registration
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	MailService mail = (MailService) ctx.getBean("mailService");
	mail.registrationMail(u);
	
	return null;
    }

}
