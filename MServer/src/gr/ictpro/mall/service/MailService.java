/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.ArrayList;

import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.EmailTranslation;
import gr.ictpro.mall.model.EmailTranslationId;
import gr.ictpro.mall.model.EmailType;
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
    public class SendMailThread implements Runnable {
	private SimpleMailMessage message;

	public SendMailThread(SimpleMailMessage message) {
	    this.message = message;
	}

	public void run() {
	    mailSender.send(message);
	}
    }

    @Autowired(required = true)
    private UserContext userContext;

    @Autowired(required = true)
    private MailSender mailSender;

    @Autowired(required = true)
    private GenericService<EmailTranslation, EmailTranslationId> emailTranslationService;

    @Autowired(required = true)
    private UserService userService;

    @Autowired(required = true)
    private GenericService<Role, Integer> roleService;

    
    private void sendMail(String from, String to, EmailTranslation email, User u)
    {
	SimpleMailMessage message = new SimpleMailMessage();
	message.setFrom(from);
	message.setTo(to);
	message.setSubject(fillInFields(email.getSubject(), u));
	message.setText(fillInFields(email.getBody(), u));
	Runnable sendMailThread = new SendMailThread(message);
	new Thread(sendMailThread).start();
    }

    private String fillInFields(String input, User u) {
	String res = input.replace("%fullname%", u.getProfile().getName());
	res = res.replace("%role%", new ArrayList<Role>(u.getRoles()).get(0).getRole());
	return res;
    }

    public void registrationMail(User u, User informUser) {
	User admin = userService.getUserByRole("Admin").get(0);

	if (!u.isEnabled()) {
	    if (u.hasRole("Teacher")) {
		// Teacher registration. Inform admin
		EmailTranslationId emailId = new EmailTranslationId("en", 0, EmailType.NEW_USER);
		EmailTranslation email = emailTranslationService.retrieveById(emailId);
		sendMail(admin.getEmail(), admin.getEmail(), email, u);

	    } else if (u.hasRole("Student") || u.hasRole("Parent")) {
		// Student registration. Inform Teachers
		EmailTranslationId emailId = new EmailTranslationId("en", 0, EmailType.NEW_USER);
		EmailTranslation email = emailTranslationService.retrieveById(emailId);
		if (informUser != null) {
		    sendMail(admin.getEmail(), informUser.getEmail(), email, u);
		} else {
		    Role r = roleService.listByProperty("role", "Teacher").get(0);
		    for (User t : r.getUsers()) {
			sendMail(admin.getEmail(), t.getEmail(), email, u);
		    }
		}
	    }
	    
	    // inform user that his account is created but is not yet enabled
	    EmailTranslationId emailId = new EmailTranslationId(userContext.getUserLang(u).getCode(), 0,
		    EmailType.DISABLED_ACCOUNT_CREATED);
	    EmailTranslation email = emailTranslationService.retrieveById(emailId);
	    sendMail(admin.getEmail(), u.getEmail(), email, u);
	}

    }

    public void accountEnabledMail(User u) {
	User admin = userService.getUserByRole("Admin").get(0);

	EmailTranslationId emailId = new EmailTranslationId(userContext.getUserLang(u).getCode(), 0,
		EmailType.ACCOUNT_ENABLED);
	EmailTranslation email = emailTranslationService.retrieveById(emailId);
	sendMail(admin.getEmail(), u.getEmail(), email, u);

    }

}
