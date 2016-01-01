/**
 * 
 */
package gr.ictpro.mall.flex;

import java.lang.annotation.Annotation;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import flex.messaging.MessageBroker;
import flex.messaging.messages.AsyncMessage;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class MessagingService {

    public static void objectsChanged(Object object) {
	String className = null;
	for (Annotation annotation : object.getClass().getDeclaredAnnotations()) {
	    Class<? extends Annotation> type = annotation.annotationType();
	    if (type.getName().equals("gr.ictpro.mall.interceptors.ClientReferenceClass")) {
		for (Method method : type.getDeclaredMethods()) {
		    try {
			className = (String) method.invoke(annotation, (Object[]) null);
		    } catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			e.printStackTrace();
		    }
		}
		break;
	    }
	}
	if (className != null) {
	    Map<String, Object> params = new LinkedHashMap<String, Object>();
	    params.put("className", className);
	    sendMessageToClients("Refresh Data", params);
	}
    }

    // public static void newNotifications(List<User> users, List<Role> roles,
    // int t) {
    // Map<String, Object> params = new LinkedHashMap<String, Object>();
    // if(users != null) {
    // ArrayList<Integer> userIds = new ArrayList<Integer>();
    // params.put("users", userIds);
    // for(User u: users) {
    // userIds.add(u.getId());
    // }
    // }
    // if(roles != null) {
    // ArrayList<String> roleNames = new ArrayList<String>();
    // params.put("roles", roleNames);
    // for(Role r: roles) {
    // roleNames.add(r.getRole());
    // }
    // }
    // sendMessageToClients("New Notifications", params);
    // }

    private static void sendMessageToClients(String subject, Map<String, Object> params) {
	AsyncMessage msg = new AsyncMessage();
	msg.setClientId("Java-Based-Producer-For-Messaging");
	msg.setTimestamp(new Date().getTime());
	msg.setMessageId("Java-Based-Producer-For-Messaging-ID");

	// destination to which the message is to be sent
	msg.setDestination("messages");
	// msg.setHeader(AsyncMessage.SUBTOPIC_HEADER_NAME, subtopic);

	// msg.setDestination("messagingService");
	// set message body
	msg.setBody("");
	msg.setHeader("Subject", subject);
	msg.setHeader("Parameters", params);

	MessageBroker.getMessageBroker("_messageBroker").routeMessageToService(msg, null);

    }
}
