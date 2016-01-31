/**
 * 
 */
package gr.ictpro.mall.context;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Component
public class UserContext {
    @Autowired(required = true)
    private GenericService<Language, Integer> languageService;

    @Autowired(required = true)
    private GenericService<Classroom, Integer> classroomService;

    @Autowired(required = true)
    private UserService userService;

    private static SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd H:mm"); 
    
    private Map<Integer, User> connectedUsers = new LinkedHashMap<Integer, User>();
    
    public User getCurrentUser() {
	User u = userService.retrieveById(((User) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getId());
	if(connectedUsers.containsKey(u.getId())) {
	    //return connectedUsers.get(u.getId());
	    addToConnectedUsers(u);
	}
	return u;
    }
    
    public Language getUserLang(User u) {
	return languageService.listByProperty("code", "en").get(0); 
    }
    
    public Classroom getCurrentClassroom(User u) {
	String hql;
	
	Date now = GregorianCalendar.getInstance().getTime();
	// Add 30 minutes
	now.setTime(now.getTime()+1000*60*30);
	
	String timeHQL = "ca.startTime <= '" + sqlDateFormat.format(now) + "' AND ca.endTime >= '" + sqlDateFormat.format(now) + "'";
	
	if(u.hasRole("Teacher")) {
	    hql = "SELECT cl FROM Classroom cl JOIN cl.calendars ca WHERE cl.teacher.id = " + u.getId() + " AND " + timeHQL;
	} else if(u.hasRole("Student")) {
	    hql = "SELECT cl FROM Classroom cl JOIN cl.calendars ca JOIN students st WHERE st.id = " + u.getId() + " AND " + timeHQL;
	} else {
	    return null;
	}
	
	List<Classroom> classrooms = classroomService.listByCustomSQL(hql);
	
	Classroom clasroom =classrooms.size()>0? classrooms.get(0):null;  
	
	connectedUsers.get(u.getId()).setCurrentClassroom(clasroom);
	
	return clasroom;
    }
    
    public void addToConnectedUsers(User user) {
	connectedUsers.put(user.getId(), user);
    }

    public void removeFromConnectedUsers(User user) {
	connectedUsers.remove(user.getId());
    }

}
