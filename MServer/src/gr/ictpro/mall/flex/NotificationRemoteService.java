/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Calendar;
import gr.ictpro.mall.model.Meeting;
import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.RoleNotification;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.UserNotification;
import gr.ictpro.mall.service.NotificationService;
import gr.ictpro.mall.utils.Serialize;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class NotificationRemoteService {
    @Autowired(required=true)
    private NotificationService notificationService;
    
    @Autowired(required = true)
    private UserContext userContext;
    
    @Autowired(required = true)
    private MeetingRemoteService meetingRemoteService;

    @Autowired(required = true)
    private CalendarRemoteService calendarRemoteService;
    

    public List<Notification> getNotifications() {
	User currentUser = userContext.getCurrentUser();
	List<Notification> res = notificationService.retrieveByUser(currentUser);
	
	List<Meeting> userMeetings = currentUser.hasRole("Admin")?new ArrayList<Meeting>():meetingRemoteService.getMeetings();
	
	// one hour in the past
	Date first = new Date(new Date().getTime() - 1000*60*60); 
	// six days in the future
	Date last = new Date(new Date().getTime() + 1000*60*60*24*6); 
	for(Meeting m:userMeetings) {
	    meetingRemoteService.fillBBBMeetingInfo(m);
	    if((m.getTime().after(first) && m.getTime().before(last) && !(m.getStatus().equals("completed") && m.isRecord())) || m.getStatus().equals("running")) {
		Notification n = new Notification(m.getName(), "gr.ictpro.mall.client.view.MeetingView", "An Online Meeting is " +(m.getStatus().equals("running")?"in progress":"scheduled"), m.getMeetingType().isInternalModule(), false);
		n.setDynamic(true);
		n.setDate(m.getTime());
		Map<String, Integer> parameters = new LinkedHashMap<String, Integer>();
		parameters.put("meeting_id", m.getId());
		n.setParameters(Serialize.serialize(parameters));
		res.add(n);
	    }
	}
	List<Calendar> userCalendars = calendarRemoteService.getCalendars();
	// now
	first = new Date(); 
	// six days in the future
	last = new Date(new Date().getTime() + 1000*60*60*24*6); 
	for(Calendar c: userCalendars) {
	    if(c.getStartTime().after(first) && c.getStartTime().before(last)) {
		Notification n = new Notification(c.getDescription(), "gr.ictpro.mall.client.view.CalendarView","An Event is scheduled", true, false);
		n.setDynamic(true);
		n.setDate(c.getStartTime());
		Map<String, Integer> parameters = new LinkedHashMap<String, Integer>();
		parameters.put("calendar_id", c.getId());
		n.setParameters(Serialize.serialize(parameters));
		res.add(n);
	    }
	}
	
	return res;
    }
    
    public void updateNotification(Notification n) {
	User currentUser = userContext.getCurrentUser();
	n = notificationService.retrieveById(n.getId());
	for(UserNotification un: n.getUserNotifications()) {
	    if(un.getUser().equals(currentUser)) {
		un.setSeen(GregorianCalendar.getInstance().getTime());
		un.setDone(true);
		notificationService.updateUserNotification(un);
	    }
	}
	for (RoleNotification rn: n.getRoleNotifications()) {
	    if(currentUser.hasRole(rn.getRole().getRole())) {
		rn.setDateHandled(GregorianCalendar.getInstance().getTime());
		rn.setUser(currentUser);
		notificationService.updateRoleNotification(rn);
	    }
	}
    }
}
