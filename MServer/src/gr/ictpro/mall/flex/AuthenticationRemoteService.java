/**
 * 
 */
package gr.ictpro.mall.flex;


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
import gr.ictpro.mall.authentication.AuthenticationMethod;
import gr.ictpro.mall.authentication.PrioritySortableComparator;
import gr.ictpro.mall.context.UserContext;
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
    private UserContext userContext;
    
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
	    userContext.addToConnectedUsers(u);
	    u.setCurrentClassroom(userContext.getCurrentClassroom(u));
	    return u;
	} else {
	    return null;
	}

    }
    public void terminateSession() {
	 HttpFlexSession flexSession = (HttpFlexSession) FlexContext.getFlexSession();
	 userContext.removeFromConnectedUsers(userContext.getCurrentUser());
	 flexSession.invalidate(true);
	 SecurityContextHolder.clearContext();
    }
    
    public List<AuthenticationMethod> getAuthenticationModules() {
	Collections.sort(authMethods, new PrioritySortableComparator());
	return authMethods;
    }

    public List<Role> getRoles() {
	return roleService.listAll();
    }

    
}
