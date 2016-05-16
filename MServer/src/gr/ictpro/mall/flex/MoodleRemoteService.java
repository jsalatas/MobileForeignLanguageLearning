package gr.ictpro.mall.flex;

import java.math.BigInteger;
import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.UserService;

public class MoodleRemoteService {
    @Autowired(required = true)
    private UserService userService;

    @Autowired(required = true)
    protected PasswordEncoder passwordEncoder;

    public String generateMoodlePassword(ASObject userObject) {
	int id = (Integer) userObject.get("id");

	User u = userService.retrieveById(id);
	SecureRandom random = new SecureRandom();
	String res = new BigInteger(130, random).toString(32).substring(0, 10);
	
	u.setMoodlePassword(passwordEncoder.encode((String) res));
	
	userService.update(u);
	
	return res;
    }
    
}
