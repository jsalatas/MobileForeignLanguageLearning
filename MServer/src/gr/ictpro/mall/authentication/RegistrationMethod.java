/**
 * 
 */
package gr.ictpro.mall.authentication;

import org.springframework.beans.factory.BeanNameAware;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.UserService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface RegistrationMethod extends BeanNameAware, PrioritySortable {
    public String getUi();
    public void setUi(String ui);
    public String getBeanName();
    public User register(ASObject registrationDetails);
    public void setUserService(UserService userService);

}
