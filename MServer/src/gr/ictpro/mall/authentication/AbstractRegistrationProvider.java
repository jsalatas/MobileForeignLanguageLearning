/**
 * 
 */
package gr.ictpro.mall.authentication;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.password.PasswordEncoder;

import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public abstract class AbstractRegistrationProvider implements RegistrationMethod {
    protected int priority;
    protected String ui;
    protected String beanName;

    @Autowired(required = true)
    protected UserService userService;

    @Autowired(required = true)
    protected GenericService<Role, Integer> roleService;
    
    @Autowired(required = true)
    protected GenericService<Profile, Integer> profileService;
    
    @Autowired(required = true)
    protected PasswordEncoder passwordEncoder;

    /* (non-Javadoc)
     * @see org.springframework.beans.factory.BeanNameAware#setBeanName(java.lang.String)
     */
    @Override
    public void setBeanName(String name) {
	this.beanName = name;
    }
    
    /* (non-Javadoc)
     * @see gr.ictpro.mall.authentication.RegistrationMethod#getUi()
     */
    @Override
    public String getUi() {
	return this.ui;
    }
    
    /* (non-Javadoc)
     * @see gr.ictpro.mall.authentication.RegistrationMethod#setUi()
     */
    @Override
    public void setUi(String ui) {
	this.ui = ui + ".swf";
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.authentication.RegistrationMethod#getBeanName()
     */
    @Override
    public String getBeanName() {
	return this.beanName;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.authentication.RegistrationMethod#getPriority()
     */
    @Override
    public int getPriority() {
	return priority;
    }

    public void setPriority(int priority) {
	this.priority = priority;
    }


}
