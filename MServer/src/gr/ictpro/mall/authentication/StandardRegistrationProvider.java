/**
 * 
 */
package gr.ictpro.mall.authentication;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.context.ContextLoader;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.MailService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Component
public class StandardRegistrationProvider extends AbstractRegistrationProvider {

    @Autowired(required = true)
    private UserContext userContext;

    @Autowired(required = true)
    private GenericService<Language, String> languageService;

    @Override
    public boolean register(ASObject registrationDetails) {

	String userName = (String) registrationDetails.get("userName");
	String name = (String) registrationDetails.get("name");
	String password = passwordEncoder.encode((String) registrationDetails.get("password"));
	String email = (String) registrationDetails.get("email");
	String languageCode = (String) registrationDetails.get("languageCode");
	if(languageCode.indexOf("-") > -1) {
	    languageCode = languageCode.substring(0, languageCode.indexOf("-")); 
	}
	Integer roleId = (Integer) registrationDetails.get("role");
	String relatedUser = (String) registrationDetails.get("relatedUser");

	User informUser = null;
	if(relatedUser != null) {
	    List<Profile> profiles = profileService.listByProperty("name", relatedUser);
	    if(profiles.size() == 1) {
		Hibernate.initialize(profiles.get(0).getUser());
		informUser = profiles.get(0).getUser();
		userContext.initUser(informUser);
	    }
	}
	
	HashSet<Role> r = new HashSet<Role>(); 
	try {
	    r.add(roleService.retrieveById(roleId.intValue()));
	} catch (Exception e) {
	    e.printStackTrace();
	}                                 
	 
	User u = new User(userName, password, email, false, false, false, true);
	u.setRoles(r);
	userService.create(u, informUser);
	Language language = languageService.retrieveById(languageCode);
	Profile p = new Profile(u, language, name);
	profileService.create(p);
	u.setProfile(p);
	
	// in case of students try to assign a classroom
	if (u.hasRole("Student") && informUser != null && informUser.getCurrentClassroom() != null) {
	    Set<Classroom> cl = new HashSet<Classroom>();
	    cl.add(informUser.getCurrentClassroom());
	    u.setClassrooms(cl);
	    userService.update(u);
	}
	
	
	// inform related users about the registration
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	MailService mail = (MailService) ctx.getBean("mailService");
	mail.registrationMail(u, informUser);
	
	return u.isEnabled();
    }

}
