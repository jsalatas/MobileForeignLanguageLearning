package gr.ictpro.mall.flex;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.MailSender;

import gr.ictpro.mall.bbb.ApiCall;
import gr.ictpro.mall.helper.DatabaseBasedMailSender;
import gr.ictpro.mall.model.Config;
import gr.ictpro.mall.service.GenericService;

public class ConfigRemoteService {
    @Autowired(required = true)
    private GenericService<Config, Integer> configService;

    @Autowired(required = true)
    private ApiCall checkSum;

    private MailSender mailSender;

    @Autowired(required = true)
    @Qualifier(value = "mailSender")
    public void setMailSender( MailSender mailSender) {
	this.mailSender = mailSender;
    }

    
    public List<Config> getConfig() {
	return configService.listAll();
    }

    public void updateConfig(List<Config> configs) {
	for(Config config:configs) {
	    Config persistentConfig = configService.retrieveById(config.getId());
	    persistentConfig.setValue(config.getValue());
	    configService.update(persistentConfig);
	}
	((DatabaseBasedMailSender)mailSender).init();
	checkSum.init();
    }

}
