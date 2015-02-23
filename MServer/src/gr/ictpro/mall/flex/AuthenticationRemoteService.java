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
import gr.ictpro.mall.service.RoleService;
import gr.ictpro.mall.service.UserService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class AuthenticationRemoteService {
    private UserService userService;
    private RoleService roleService;
    
    private List<AuthenticationMethod> authMethods;
    private List<RegistrationMethod> registrationMethods;
    
    private List<User> connectedUsers = new ArrayList<User>(); 
    
    public void setUserService(UserService userService) {
	this.userService = userService;
    }

    public void setRoleService(RoleService roleService) {
	this.roleService = roleService;
    }

    @Autowired(required = true)
    public void setAuthMethods(List<AuthenticationMethod> authMethods) {
	this.authMethods = authMethods;
	Collections.sort(authMethods, new PrioritySortableComparator());
    }

    @Autowired(required = true)
    public void setRegistrationMethods(List<RegistrationMethod> registrationMethods) {
	this.registrationMethods = registrationMethods;
	Collections.sort(registrationMethods, new PrioritySortableComparator());
    }

    public User login(ASObject authenticationDetails) {
	try {
	    ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();  
	    AuthenticationMethod auth = (AuthenticationMethod) ctx.getBean((String) authenticationDetails.get("authenticationMethod")); 
	    Authentication authentication = auth.getAuthenticationToken(authenticationDetails);
	    authentication = auth.authenticate(authentication);
	    SecurityContextHolder.getContext().setAuthentication(authentication);
	    User u = userService.listByProperty("username", authenticationDetails.get("username")).get(0);
	    addToConnectedUsers(u);
	    return u;
	} catch (Exception e) {
	    e.printStackTrace();
	    SecurityContextHolder.getContext().setAuthentication(null);
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
	MessagingService.sendMessageToClients("user disconnected");
    }

    private void addToConnectedUsers(User u) {
	connectedUsers.add(u);
	MessagingService.sendMessageToClients("user connected");
    }


    public ArrayList<String> getAuthenticationModules() {
	ArrayList<String> res = new ArrayList<String>();
	for(AuthenticationMethod a: authMethods) {
	    res.add(a.getUi());
	}
	
	return res;
    }

    public ArrayList<String> getRegistrationModules() {
	ArrayList<String> res = new ArrayList<String>();
	for(RegistrationMethod a: registrationMethods) {
	    res.add(a.getUi());
	}
	
	return res;
    }

    public List<Role> getRoles() {
	List<Role> roles = roleService.listAll();
	
	// Remove admin role
	roles.remove(roleService.listByProperty("role", "Admin").get(0));
	
	return roles;
    }

    
}
