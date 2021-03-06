/**
 * 
 */
package gr.ictpro.mall.authentication;

import org.springframework.beans.factory.BeanNameAware;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.AuthenticationProvider;

import flex.messaging.io.amf.ASObject;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface AuthenticationMethod extends AuthenticationProvider, BeanNameAware, PrioritySortable {
    public String getUi();
    public void setUi(String ui);
    public String getClientClassName();
    public void setClientClassName(String clientClassName);
    public AbstractAuthenticationToken getAuthenticationToken(ASObject authenticationDetails);
    public String getBeanName();
}
