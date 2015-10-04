/**
 * 
 */
package gr.ictpro.mall.authentication;

import org.springframework.beans.factory.BeanNameAware;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.AuthenticationProvider;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.service.UserService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface AuthenticationMethod extends AuthenticationProvider, BeanNameAware, PrioritySortable {
    public String getUi();
    public void setUi(String ui);
    public AbstractAuthenticationToken getAuthenticationToken(ASObject authenticationDetails);
    public String getBeanName();
}
