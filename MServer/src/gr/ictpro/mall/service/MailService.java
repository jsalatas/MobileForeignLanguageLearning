/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.Set;

import gr.ictpro.mall.model.Email;
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

    @Autowired(required = true)
    private MailSender mailSender;

    @Autowired(required = true)
    private GenericService<Email, Integer> emailService;

    @Autowired(required = true)
    private GenericService<Role, Integer> roleService;

    @Autowired(required = true)
    private UserService userService;

    private static enum EMAIL_TYPE {
	NEW_TEACHER,
	DISABLED_ACCOUNT_CREATED,
	ACCOUNT_ENABLED
    }

    private void sendMail(String from, String to, Email email, User u)
    {
	SimpleMailMessage message = new SimpleMailMessage();
	message.setFrom(from);
	message.setTo(to);
	message.setSubject(email.getSubject());
	message.setText(fillInFields(email.getBody(), u));
	mailSender.send(message);
    }

    private String fillInFields(String input, User u) {
	String res = input.replace("%fullname%", u.getProfile().getName());
	return res;
    }
    
    public void registrationMail(User u) {
	User admin = userService.getUserByRole("Admin").get(0);
	
	if (u.hasRole("Teacher")) {
	    // Teacher registration. Inform admin
	    Email email = emailService.retrieveById(EMAIL_TYPE.NEW_TEACHER.ordinal()+1);
	    sendMail(admin.getEmail(), admin.getEmail(), email, u);

	} else if (u.hasRole("Student")) {
	    // Student registration. Inform teacher
	} else if (u.hasRole("Parent")) {
	    // Parent registration. Inform teacher and student
	}

	if (!u.isEnabled()) {
	    // inform user that his account is created but is not yet enabled
	    Email email = emailService.retrieveById(EMAIL_TYPE.DISABLED_ACCOUNT_CREATED.ordinal()+1);
	    sendMail(admin.getEmail(), u.getEmail(), email, u);
	}

    }

}
