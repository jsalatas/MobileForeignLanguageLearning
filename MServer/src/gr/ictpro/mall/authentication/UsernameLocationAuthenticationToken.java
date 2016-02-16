package gr.ictpro.mall.authentication;

import java.util.Collection;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

public class UsernameLocationAuthenticationToken extends AbstractAuthenticationToken {
    private static final long serialVersionUID = 4469290426123971355L;
    
    private final Object principal;
    private Object credentials;

    public UsernameLocationAuthenticationToken(Object principal, Object credentials) {
        super(null);
        this.principal = principal;
        this.credentials = credentials;
        setAuthenticated(false);
    }

    public UsernameLocationAuthenticationToken(Object principal, Object credentials, Collection<? extends GrantedAuthority> authorities) {
        super(authorities);
        this.principal = principal;
        this.credentials = credentials;
        super.setAuthenticated(true); // must use super, as we override
    }

    @Override
    public Object getCredentials() {
	return this.credentials;
    }

    @Override
    public Object getPrincipal() {
	return this.principal;
    }

}
