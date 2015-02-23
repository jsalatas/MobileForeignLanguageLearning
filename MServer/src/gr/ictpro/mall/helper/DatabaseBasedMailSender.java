/**
 * 
 */
package gr.ictpro.mall.helper;

import java.util.List;
import java.util.Properties;

import gr.ictpro.mall.model.Config;
import gr.ictpro.mall.service.ConfigService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.javamail.JavaMailSenderImpl;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class DatabaseBasedMailSender extends JavaMailSenderImpl {
    private ConfigService configService;

    @Autowired(required = true)
    public DatabaseBasedMailSender(@Qualifier(value = "configService") ConfigService configService) {
	super();
	this.configService = configService;
	init();
    }

    private void init() {
	setHost(configService.listByProperty("name", "mail.host").get(0).getValue());
	setPort(Integer.parseInt(configService.listByProperty("name", "mail.port").get(0).getValue()));
	setUsername(configService.listByProperty("name", "mail.username").get(0).getValue());
	setPassword(configService.listByProperty("name", "mail.password").get(0).getValue());
	Properties mailProperties = new Properties();
	mailProperties.setProperty("mail.transport.protocol", configService.listByProperty("name", "mail.transport.protocol").get(0).getValue());
	mailProperties.setProperty("mail.smtp.auth", configService.listByProperty("name", "mail.smtp.auth").get(0).getValue());
	mailProperties.setProperty("mail.smtp.starttls.enable", configService.listByProperty("name", "mail.smtp.starttls.enable").get(0).getValue());
	mailProperties.setProperty("mail.debug", configService.listByProperty("name", "mail.debug").get(0).getValue());
	setJavaMailProperties(mailProperties);
    }

}
