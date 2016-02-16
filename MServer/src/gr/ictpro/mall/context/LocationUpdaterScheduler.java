package gr.ictpro.mall.context;

import gr.ictpro.mall.flex.MessagingService;

import java.util.Date;

import org.springframework.scheduling.annotation.Scheduled;

public class LocationUpdaterScheduler {
    
    @Scheduled(fixedRate=300000)
    public void sendUpdateLocationMessage() {
	System.err.println("update location " + (new Date()));
	MessagingService.sendUpdateLocationMessage();
    }

}
