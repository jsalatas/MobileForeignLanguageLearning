/**
 * 
 */
package gr.ictpro.mall.authentication;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.password.PasswordEncoder;

import gr.ictpro.mall.service.ProfileService;
import gr.ictpro.mall.service.RoleService;
import gr.ictpro.mall.service.UserService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public abstract class AbstractRegistrationProvider implements RegistrationMethod {
    protected int priority;
    protected String ui;
    protected String beanName;
    protected UserService userService;
    protected RoleService roleService;
    protected ProfileService profileService;
    protected PasswordEncoder passwordEncoder;


    /* (non-Javadoc)
     * @see org.springframework.beans.factory.BeanNameAware#setBeanName(java.lang.String)
     */
    @Override
    public void setBeanName(String name) {
	this.beanName = name;
    }
    
    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.authentication.RegistrationMethod#setUserService(gr.ictpro.mall.service.UserService)
     */
    @Autowired(required = true)
    @Qualifier(value = "userService")
    public void setUserService(UserService userService) {
	this.userService = userService;
    }

    @Autowired(required = true)
    @Qualifier(value = "roleService")
    public void setRoleService(RoleService roleService) {
	this.roleService = roleService;
    }
    @Autowired(required = true)
    @Qualifier(value = "profileService")
    public void setProfileService(ProfileService profileService) {
	this.profileService = profileService;
    }

    /*
     * 
     */
    @Autowired(required = true)
    @Qualifier(value = "passwordEncoder")
    public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
	this.passwordEncoder = passwordEncoder;
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
