package gr.ictpro.mall.flex;

import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Meeting;
import gr.ictpro.mall.model.MeetingType;
import gr.ictpro.mall.model.MeetingUser;
import gr.ictpro.mall.model.MeetingUserId;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

public class MeetingRemoteService {

    @Autowired(required = true)
    private GenericService<Meeting, Integer> meetingService;

    @Autowired(required = true)
    private GenericService<MeetingType, Integer> meetingTypeService;

    @Autowired(required = true)
    private GenericService<MeetingUser, MeetingUserId> meetingUserService;

    @Autowired(required = true)
    private UserContext userContext;

    public List<MeetingType> getMeetingTypes() {
	return meetingTypeService.listAll();
    }
    
    public List<Meeting> getMeetings() {
	User currentUser = userContext.getCurrentUser();
	List<Meeting> res = new ArrayList<Meeting>();
	
	if(currentUser.hasRole("Admin")) {
	    res = meetingService.listAll();
	    
	} else if(currentUser.hasRole("Student")) {
	    String hql = "Select DISTINCT m FROM Meeting m JOIN m.meetingUsers mu WHERE mu.user.id = " + currentUser.getId();
	    res = meetingService.listByCustomSQL(hql);
	}else if(currentUser.hasRole("Teacher")) {
	    List<Integer> userIds = new ArrayList<Integer>();
	    for(Classroom classroom: currentUser.getTeacherClassrooms()) {
		for(User u:classroom.getStudents()) {
		    userIds.add(u.getId());
		}
	    }
	    
	    String hql = "Select DISTINCT m FROM Meeting m JOIN m.meetingUsers mu WHERE mu.user.id IN ("+StringUtils.join(userIds, ", ")+")";
	    res = meetingService.listByCustomSQL(hql);
	} else if(currentUser.hasRole("Parent")) {
	    List<Integer> userIds = new ArrayList<Integer>();
	    for(User u: currentUser.getChildren()) {
		userIds.add(u.getId());
	    }
	    
	    String hql = "Select DISTINCT m FROM Meeting m JOIN m.meetingUsers mu WHERE mu.user.id IN ("+StringUtils.join(userIds, ", ")+")";
	    res = meetingService.listByCustomSQL(hql);
	    
	}
	
	//TODO: 
	return res;
    }
    
    public void deleteMeeting(Meeting meeting) {
	User currentUser = userContext.getCurrentUser();
	
	if(currentUser.hasRole("Admin")) {
	    meetingService.delete(meetingService.retrieveById(meeting.getId()));
	}
    }
    
    public void updateMeeting(Meeting meeting) {
	boolean now = meeting.getTime() == null;
	if(now) {
	    meeting.setTime(new Date());
	}
	User currentUser = userContext.getCurrentUser();
	if(currentUser.hasRole("Admin") || currentUser.hasRole("Teacher")) {
	    if(meeting.isApprove()) {
		meeting.setApprovedBy(currentUser);
	    } else {
		meeting.setApprovedBy(null);
	    }
	}
	String nameSalt = UUID.randomUUID().toString().replace("-", "");
	Set<User> pendingUsers = new HashSet<User>(meeting.getUsers());
	
	if(meeting.getId() == null) {
	    meeting.setCreatedBy(currentUser);
	    String password = UUID.randomUUID().toString().replace("-", "");
	    meeting.setName(meeting.getName()+ "---"+nameSalt);
	    meeting.setPassword(password);
	    meetingService.create(meeting);
	    for(User u:pendingUsers) {
		MeetingUser mu = new MeetingUser(new MeetingUserId(meeting.getId(), u.getId()), meeting, u);
		meetingUserService.create(mu);
	    }
	} else {
	    Meeting persistentMeeting = meetingService.retrieveById(meeting.getId());
	    if(!persistentMeeting.getName().substring(0, persistentMeeting.getName().indexOf("---")).equals(meeting.getName())) {
		persistentMeeting.setName(meeting.getName()+ "---"+nameSalt);
	    }
	    persistentMeeting.setApprovedBy(meeting.getApprovedBy());
	    persistentMeeting.setTime(meeting.getTime());
	    
	    meetingService.update(persistentMeeting);
	    
	    // modify users

	    Set<User> usersToRemove = new HashSet<User>();
	    Set<User> usersToAdd = new HashSet<User>();

	    // find new users
	    for (User u : pendingUsers) {
		boolean found = false;
		for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		    if (mu.getUser().getId().intValue() == u.getId().intValue()) {
			found = true;
			break;
		    }
		}
		if (!found) {
		    usersToAdd.add(u);
		}
	    }

	    // find users to remove
	    for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		boolean found = false;
		for (User u : pendingUsers) {
		    if (mu.getUser().getId().intValue() == u.getId().intValue()) {
			found = true;
			break;
		    }
		}
		if (!found) {
		    usersToRemove.add(mu.getUser());
		}
	    }

	    // remove users
	    for (User u : usersToRemove) {
		for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		    if (mu.getUser().getId().intValue() == u.getId().intValue()) {
			meetingUserService.delete(mu);
			break;
		    }
		}
	    }

	    // add users
	    for (User u : usersToAdd) {
		MeetingUserId muid = new MeetingUserId(persistentMeeting.getId(), u.getId());
		MeetingUser mu = new MeetingUser(muid, persistentMeeting, u);
		meetingUserService.create(mu);
	    }
	    
	}
    }
    
}
