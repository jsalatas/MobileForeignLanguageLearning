package gr.ictpro.mall.authentication;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;

import flex.messaging.io.amf.ASObject;

public class ProximityAuthenticationProvider extends AbstractAuthenticationProvider {

    @Override
    public AbstractAuthenticationToken getAuthenticationToken(ASObject authenticationDetails) {
	// TODO Auto-generated method stub
	return null;
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
	// TODO Auto-generated method stub
	return null;
    }

}
