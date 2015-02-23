/**
 * 
 */
package gr.ictpro.mall.authentication;

import gr.ictpro.mall.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public abstract class AbstractAuthenticationProvider implements AuthenticationMethod, BeanNameAware {
    protected int priority;
    protected String ui;
    protected String beanName;

    protected UserService userService;
    protected PasswordEncoder passwordEncoder;

    @Autowired(required = true)
    @Qualifier(value = "userService")
    public void setUserService(UserService userService) {
	this.userService = userService;
    }

    @Autowired(required = true)
    @Qualifier(value = "passwordEncoder")
    public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
	this.passwordEncoder = passwordEncoder;
    }

    @Override
    public String getBeanName() {
	return this.beanName;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.springframework.beans.factory.BeanNameAware#setBeanName(java.lang
     * .String)
     */
    @Override
    public void setBeanName(String name) {
	this.beanName = name;
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.springframework.security.authentication.AuthenticationProvider#
     * authenticate(org.springframework.security.core.Authentication)
     */
    @Override
    public abstract Authentication authenticate(Authentication authentication) throws AuthenticationException;

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.springframework.security.authentication.AuthenticationProvider#supports
     * (java.lang.Class)
     */
    @Override
    public boolean supports(Class<?> authentication) {
	return (UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication));
    }

    @Override
    public String getUi() {
	return ui;
    }

    @Override
    public int getPriority() {
	return priority;
    }

    @Override
    public void setUi(String ui) {
	this.ui = ui + ".swf";
    }

    public void setPriority(int priority) {
	this.priority = priority;
    }

}
