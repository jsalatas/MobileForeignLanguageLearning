package gr.ictpro.mall.authentication;

import java.util.ArrayList;
import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.context.LocationContext;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.WifiTag;

public class ProximityAuthenticationProvider extends AbstractAuthenticationProvider {

    @Autowired(required = true)
    private LocationContext locationContext;

    @Override
    public AbstractAuthenticationToken getAuthenticationToken(ASObject authenticationDetails) {
	String username = (String) authenticationDetails.get("username");
	ASObject credentials =(ASObject) authenticationDetails.get("credentials");
	return new UsernameLocationAuthenticationToken(username, credentials);
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
	String username = authentication.getName();
	String password = (String)((ASObject)authentication.getCredentials()).get("password");
	ArrayList<WifiTag> currentLocation = new ArrayList<WifiTag>(locationContext.parseLocationTags((ASObject)((ASObject)authentication.getCredentials()).get("contextInfo")));
	
	User user = null;
	try {
	    user = userService.listByProperty("username", username).get(0);
	} catch (Exception e) {
	    throw new BadCredentialsException("Incorrect username and/or password.");
	}
       
	if(password != null) {
            if (!passwordEncoder.matches(password, user.getPassword())) {
                throw new BadCredentialsException("Incorrect username and/or password.");
            }
            locationContext.storeLocation(user, currentLocation);
	} else {
	    if (!locationContext.isInKnownLocation(user, currentLocation)) {
		throw new BadCredentialsException("Incorrect username and/or password.");
	    }
	}
        Collection<Role> authorities = user.getRoles();
        return new UsernameLocationAuthenticationToken(user, authentication.getCredentials(), authorities);            

    }
}
