/**
 * 
 */
package gr.ictpro.mall.service;


import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import gr.ictpro.mall.model.EmailTranslation;
import gr.ictpro.mall.model.EmailTranslationId;
import gr.ictpro.mall.model.EmailType;
import gr.ictpro.mall.model.Role;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.utils.Context;

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
    private Context context;

    @Autowired(required = true)
    private MailSender mailSender;

    @Autowired(required = true)
    private GenericService<EmailTranslation, EmailTranslationId> emailTranslationService;

    @Autowired(required = true)
    private GenericService<Role, Integer> roleService;

    @Autowired(required = true)
    private UserService userService;

    private void sendMail(String from, String to, EmailTranslation email, User u)
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
	    EmailTranslationId emailId = new EmailTranslationId("en", 0, EmailType.NEW_TEACHER);
	    EmailTranslation email = emailTranslationService.retrieveById(emailId);
	    sendMail(admin.getEmail(), admin.getEmail(), email, u);

	} else if (u.hasRole("Student")) {
	    // Student registration. Inform teacher
	} else if (u.hasRole("Parent")) {
	    // Parent registration. Inform teacher and student
	}

	if (!u.isEnabled()) {
	    // inform user that his account is created but is not yet enabled
	    EmailTranslationId emailId = new EmailTranslationId(context.getUserLang(u).getCode(), 0, EmailType.DISABLED_ACCOUNT_CREATED);
	    EmailTranslation email = emailTranslationService.retrieveById(emailId);
	    sendMail(admin.getEmail(), u.getEmail(), email, u);
	}

    }

    public void accountEnabledMail(User u) {
	User admin = userService.getUserByRole("Admin").get(0);

	EmailTranslationId emailId = new EmailTranslationId(context.getUserLang(u).getCode(), 0, EmailType.ACCOUNT_ENABLED);
	EmailTranslation email = emailTranslationService.retrieveById(emailId);
	sendMail(admin.getEmail(), admin.getEmail(), email, u);

    }
}
