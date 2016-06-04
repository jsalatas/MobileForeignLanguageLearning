package gr.ictpro.mall.flex;

import java.math.BigInteger;
import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Config;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

public class MoodleRemoteService {
    @Autowired(required = true)
    private UserService userService;

    @Autowired(required = true)
    protected PasswordEncoder passwordEncoder;

    @Autowired(required = true)
    private GenericService<Config, Integer> configService;

    public String generateMoodleURL(ASObject userObject) {
	int userId = (Integer) userObject.get("userId");
	int courseId = (Integer) userObject.get("courseId");

	User u = userService.retrieveById(userId);
	SecureRandom random = new SecureRandom();
	String password = new BigInteger(130, random).toString(32).substring(0, 10);
	
	String enc = passwordEncoder.encode(password);
	
	u.setMoodlePassword(enc);
	
	userService.update(u);
	
	String res = configService.listByProperty("name", "moodle.url").get(0).getValue();
	if(!res.endsWith("/")) {
	    res +="/";
	}
	
	res +="noncelogin/login.php?mode=login&username="+u.getUsername()+"&password="+password+"&courseId="+courseId;

	return res;
    }
    
}
