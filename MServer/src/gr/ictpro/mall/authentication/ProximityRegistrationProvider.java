package gr.ictpro.mall.authentication;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoader;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.context.LocationContext;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.WifiTag;
import gr.ictpro.mall.service.MailService;

public class ProximityRegistrationProvider extends AbstractRegistrationProvider {

    @Autowired(required = true)
    private LocationContext locationContext;

    @Autowired(required = true)
    private UserContext userContext;


    @Override
    public boolean register(ASObject registrationDetails) {
	String userName = (String) registrationDetails.get("userName");
	String name = (String) registrationDetails.get("name");
	String password = passwordEncoder.encode((String) registrationDetails.get("password"));
	String email = (String) registrationDetails.get("email");
	Integer roleId = (Integer) registrationDetails.get("role");
	String relatedUser = (String) registrationDetails.get("relatedUser");
	ArrayList<WifiTag> currentLocation = new ArrayList<WifiTag>(locationContext.parseLocationTags((ASObject)registrationDetails.get("contextInfo")));
	
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
	
	// check if we should enable
	if (u.hasRole("Teacher")) {
	    // inform admin
	    informUser = userService.listByProperty("username", "admin").get(0);
	    userContext.initUser(informUser);
	    u.setEnabled(locationContext.isInProximity(new ArrayList<WifiTag>(informUser.getCurrentLocation()),
		    currentLocation));
	} else if (u.hasRole("Student")) {
	    if (informUser != null) {
		userContext.initUser(informUser);
		u.setEnabled(locationContext.isInProximity(new ArrayList<WifiTag>(informUser.getCurrentLocation()),
			currentLocation));
		if (u.isEnabled()) {
		    locationContext.storeLocation(u, currentLocation);
		}

		// in case of students try to assign a classroom
		if (informUser.getCurrentClassroom() != null) {
		    Set<Classroom> cl = new HashSet<Classroom>();
		    cl.add(informUser.getCurrentClassroom());
		    u.setClassrooms(cl);
		    userService.update(u);
		}
	    }
	} else {
	    // TODO: Parent registration
	}		
	
	
	userService.create(u, informUser);
	Profile p = new Profile(u, name);
	profileService.create(p);
	u.setProfile(p);
	
	if (u.isEnabled()) {
	    locationContext.storeLocation(u, currentLocation);
	}


	
	// inform related users about the registration
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	MailService mail = (MailService) ctx.getBean("mailService");
	mail.registrationMail(u, informUser);
	
	
	return u.isEnabled();
    }

}
