/**
 * 
 */
package gr.ictpro.mall.flex;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.authentication.AuthenticationMethod;
import gr.ictpro.mall.authentication.RegistrationMethod;
import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.ProfileService;
import gr.ictpro.mall.service.UserService;

import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.ContextLoader;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class UserRemoteService {

    private UserService userService;
    private ProfileService profileService;

    public void setUserService(UserService userService) {
	this.userService = userService;
    }

    public void setProfileService(ProfileService profileService) {
	this.profileService = profileService;
    }

    public User register(ASObject registrationDetails) {
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	RegistrationMethod reg = (RegistrationMethod) ctx.getBean((String) registrationDetails.get("registrationMethod"));
	return reg.register(registrationDetails);
    }

}
