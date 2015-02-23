/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.Date;

import flex.messaging.MessageBroker;
import flex.messaging.messages.AsyncMessage;
import flex.messaging.messages.Message;
import flex.messaging.services.MessageService;
import flex.messaging.services.ServiceAdapter;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class MessagingService {
    
    public static void sendMessageToClients(String messageBody) {
	AsyncMessage msg = new AsyncMessage();
	msg.setClientId("Java-Based-Producer-For-Messaging");
	msg.setTimestamp(new Date().getTime());
	msg.setMessageId("Java-Based-Producer-For-Messaging-ID");

	// destination to which the message is to be sent
	msg.setDestination("messages");
	//msg.setHeader(AsyncMessage.SUBTOPIC_HEADER_NAME, subtopic);
	
	//msg.setDestination("messagingService");
	// set message body
	msg.setBody(messageBody != null ? messageBody : "");
	msg.setHeader("sender", "From the server");

	MessageBroker.getMessageBroker("_messageBroker").routeMessageToService(msg, null);

    }
}
