/**
 * 
 */
package gr.ictpro.mall.authentication;

import org.springframework.beans.factory.BeanNameAware;

import flex.messaging.io.amf.ASObject;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface RegistrationMethod extends BeanNameAware, PrioritySortable {
    public String getUi();
    public void setUi(String ui);
    public String getClientClassName();
    public void setClientClassName(String clientClassName);
    public String getBeanName();
    /**
     * 
     * @param registrationDetails
     * @return true if account is enabled, false if account is disabled
     */
    public boolean register(ASObject registrationDetails);

}
