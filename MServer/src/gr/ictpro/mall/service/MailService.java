/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.Set;

import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service("mailService")
public class MailService {

    @Autowired(required=true)
    private MailSender mailSender;

    @Autowired(required=true)
    private GenericService<Role, Integer> roleService;

    @Autowired(required=true)
    private UserService userService;

    private void sendMail(String from, String to, String subject, String body)
    {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(from);
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);
        mailSender.send(message);
    }
    
    public void registrationMail(User u) {
	Set<Role> roles = u.getRoles();
	if(roles.contains(roleService.listByProperty("role", "Teacher").get(0))) {
	    // Teacher registration. Inform admin
	    User admin = userService.getUserByRole("Admin").get(0);
	    System.err.println(admin);
	    
	} else if(roles.contains(roleService.listByProperty("role", "Student").get(0))) {
	    // Student registration. Inform teacher 
	} else if(roles.contains(roleService.listByProperty("role", "Parent").get(0))) {
	    // Parent registration. Inform teacher and student 
	}
    }
     
}
