/**
 * 
 */
package gr.ictpro.mall.flex;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.authentication.RegistrationMethod;
import gr.ictpro.mall.model.User;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoader;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class UserRemoteService {

    public User register(ASObject registrationDetails) {
	ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	RegistrationMethod reg = (RegistrationMethod) ctx.getBean((String) registrationDetails.get("registrationMethod"));
	return reg.register(registrationDetails);
    }

}
