/**
 * 
 */
package gr.ictpro.mall.authentication;

import java.util.Collection;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Component
public class StandardAuthenticationProvider extends AbstractAuthenticationProvider {
    /*
     * (non-Javadoc)
     * 
     * @see org.springframework.security.authentication.AuthenticationProvider#
     * authenticate(org.springframework.security.core.Authentication)
     */
    @Override
    @Transactional
    public Authentication authenticate(Authentication authentication)
	    throws AuthenticationException {
	String username = authentication.getName();
	String password = (String) authentication.getCredentials();

	User user = null;
	try {
	    user = userService.listByProperty("username", username).get(0);
	} catch (Exception e) {
	    throw new BadCredentialsException("Incorrect username and/or password.");
	}

	if (!passwordEncoder.matches(password, user.getPassword())) {
	    throw new BadCredentialsException("Incorrect username and/or password.");
	}
	
	Collection<Role> authorities = user.getRoles();
	return new UsernamePasswordAuthenticationToken(user, password, authorities);
    }

    @Override
    public AbstractAuthenticationToken getAuthenticationToken(ASObject authenticationDetails) {
	String username = (String) authenticationDetails.get("username");
	String password = (String) authenticationDetails.get("credentials");
	return new UsernamePasswordAuthenticationToken(username, password);
    }
}
