package gr.ictpro.mall.flex;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.MailSender;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.helper.DatabaseBasedMailSender;
import gr.ictpro.mall.model.Config;
import gr.ictpro.mall.service.ConfigService;

public class ConfigRemoteService {
    private ConfigService configService;
    private MailSender mailSender;

    public void setConfigService(ConfigService configService) {
	this.configService = configService;
    }

    @Autowired(required = true)
    @Qualifier(value = "mailSender")
    public void setMailSender( MailSender mailSender) {
	this.mailSender = mailSender;
    }

    
    public List<Config> getConfig() {
	return configService.listAll();
    }

    public void saveConfig(ASObject configObject) {
	for(Object key: configObject.keySet()) {
	    Config c = configService.listByProperty("name", key).get(0);
	    c.setValue((String) configObject.get(key));
	    configService.update(c);
	}
	
	((DatabaseBasedMailSender)mailSender).init();
    }

}
