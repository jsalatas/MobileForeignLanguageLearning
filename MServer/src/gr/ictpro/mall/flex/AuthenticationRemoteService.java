/**
 * 
 */
package gr.ictpro.mall.flex;


import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.ContextLoader;

import flex.messaging.FlexContext;
import flex.messaging.HttpFlexSession;
import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.authentication.PrioritySortableComparator;
import gr.ictpro.mall.authentication.AuthenticationMethod;
import gr.ictpro.mall.authentication.RegistrationMethod;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class AuthenticationRemoteService {
    @Autowired(required = true)
    private UserService userService;
    
    @Autowired(required=true)
    private GenericService<Role, Integer> roleService;
    
    @Autowired(required = true)
    private List<AuthenticationMethod> authMethods;

    @Autowired(required = true)
    private List<RegistrationMethod> registrationMethods;
    
    private List<User> connectedUsers = new ArrayList<User>(); 
    
    public User login(ASObject authenticationDetails) {
	User u = null;
	try {
	    ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();  
	    AuthenticationMethod auth = (AuthenticationMethod) ctx.getBean((String) authenticationDetails.get("authenticationMethod")); 
	    Authentication authentication = auth.getAuthenticationToken(authenticationDetails);
	    authentication = auth.authenticate(authentication);
	    SecurityContextHolder.getContext().setAuthentication(authentication);
	    u = userService.listByProperty("username", authenticationDetails.get("username")).get(0);
	} catch (Exception e) {
	    e.printStackTrace();
	    SecurityContextHolder.getContext().setAuthentication(null);
	    return null;
	}
	if(u!=null && u.isEnabled()) {
	    addToConnectedUsers(u);
	    return u;
	} else {
	    return null;
	}

    }
    public void logout(String userName) {
	 HttpFlexSession flexSession = (HttpFlexSession) FlexContext.getFlexSession();
	 flexSession.invalidate(true);
	 SecurityContextHolder.clearContext();
	 User u = userService.listByProperty("username", userName).get(0);
	 removeFromConnectedUsers(u);
	 
    }
    
    private void removeFromConnectedUsers(User u) {
	connectedUsers.remove(u);
	//MessagingService.sendMessageToClients("user disconnected");
    }

    private void addToConnectedUsers(User u) {
	connectedUsers.add(u);
	//MessagingService.sendMessageToClients("user connected");
    }


    public List<AuthenticationMethod> getAuthenticationModules() {
	return authMethods;
    }

    public List<RegistrationMethod> getRegistrationModules() {
	return registrationMethods;
    }

    public List<Role> getRoles() {
	List<Role> roles = roleService.listAll();
	
	// Remove admin role
	roles.remove(roleService.listByProperty("role", "Admin").get(0));
	
	return roles;
    }

    
}
