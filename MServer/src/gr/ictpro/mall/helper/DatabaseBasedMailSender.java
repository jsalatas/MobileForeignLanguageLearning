/**
 * 
 */
package gr.ictpro.mall.helper;

import java.util.Properties;

import gr.ictpro.mall.model.Config;
import gr.ictpro.mall.service.GenericService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.MailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class DatabaseBasedMailSender extends JavaMailSenderImpl {
    private GenericService<Config, Integer> configService;

    @Autowired(required = true)
    public DatabaseBasedMailSender(@Qualifier(value = "configService") GenericService<Config, Integer> configService) {
	super();
	this.configService = configService;
	init();
    }

    public void init() {
	setHost(configService.listByProperty("name", "mail.smtp_hostname").get(0).getValue());
	setPort(Integer.parseInt(configService.listByProperty("name", "mail.smtp_port").get(0).getValue()));
	setUsername(configService.listByProperty("name", "mail.smtp_username").get(0).getValue());
	setPassword(configService.listByProperty("name", "mail.smtp_password").get(0).getValue());
	Properties mailProperties = new Properties();
	mailProperties.setProperty("mail.transport.protocol", "smtp");
	mailProperties.setProperty("mail.smtp.auth", configService.listByProperty("name", "mail.smtp_auth").get(0).getValue());
	mailProperties.setProperty("mail.smtp.starttls.enable", configService.listByProperty("name", "mail.smtp_starttls_enable").get(0).getValue());
	mailProperties.setProperty("mail.debug", configService.listByProperty("name", "mail.debug").get(0).getValue());
	setJavaMailProperties(mailProperties);
    }

}
