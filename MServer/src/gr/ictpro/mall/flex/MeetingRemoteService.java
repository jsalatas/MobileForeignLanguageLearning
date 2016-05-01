package gr.ictpro.mall.flex;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.bbb.ApiCall;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Meeting;
import gr.ictpro.mall.model.MeetingType;
import gr.ictpro.mall.model.MeetingUser;
import gr.ictpro.mall.model.MeetingUserId;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

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
    private UserService userService;

    @Autowired(required = true)
    private UserContext userContext;

    @Autowired(required = true)
    private ApiCall bbbApiCall;

    public List<MeetingType> getMeetingTypes() {
	return meetingTypeService.listAll();
    }

    public String getMeetingURL(ASObject meetingObject) {
	int id = (Integer) meetingObject.get("id");
	Meeting meeting = meetingService.retrieveById(id);

	String url = null;
	
	User currentUser = userContext.getCurrentUser();
	if(!meeting.isCurrentUserIsApproved()) {
	    return url;
	}
	
	if(meeting.getCreatedBy().getId().intValue() == currentUser.getId().intValue()) {
	    String record ="false";
	    String status =bbbApiCall.getMeetingStatus(meeting.getId().toString(), meeting.getModeratorPassword()); 
	    if(!status.equals("running")) {
		// create it 
		bbbApiCall.createMeeting(meeting.getId().toString(), meeting.getName(), record, "", meeting.getModeratorPassword(), "", meeting.getUserPassword(), null, null);
	    }
	    url = bbbApiCall.getJoinMeetingURL(currentUser.getProfile().getName(), meeting.getId().toString(), meeting.getModeratorPassword(), null);
	} else {
	    for(MeetingUser mu:meeting.getMeetingUsers()) {
		if(mu.getUser().getId().intValue() == currentUser.getId().intValue()) {
		    url = bbbApiCall.getJoinURLViewer(currentUser.getProfile().getName(), meeting.getId().toString());
		    break;
		}
	    }
	}
	
	return url;
    }
    
    private void fillBBBMeetingInfo(Meeting meeting) {
	System.err.println("meeting " + meeting.getId());
	System.err.println("running " +bbbApiCall.isMeetingRunning(meeting.getId().toString()));
	System.err.println("info " +bbbApiCall.getMeetingInfo(meeting.getId().toString(), meeting.getModeratorPassword()));
	String status = bbbApiCall.getMeetingStatus(meeting.getId().toString(), meeting.getModeratorPassword());
	if(status.equals("unknown")) {
	    Date now = new Date();
	    if(meeting.getTime().compareTo(now)>=0) {
		status = "future";
	    } else {
		status = "completed";
	    }
	}
	meeting.setStatus(status);
    }
    
    public Meeting getMeeting(ASObject meetingObject) {
	int id = (Integer) meetingObject.get("id");
	Meeting m = meetingService.retrieveById(id);

	fillBBBMeetingInfo(m);
	
	return m;
    }

    public List<Meeting> getMeetings() {
	User currentUser = userContext.getCurrentUser();
	List<Meeting> res = new ArrayList<Meeting>();

	if (currentUser.hasRole("Admin")) {
	    res = meetingService.listAll();
	} else if (currentUser.hasRole("Student")) {
	    String hql = "Select DISTINCT m FROM Meeting m JOIN m.meetingUsers mu WHERE mu.user.id = "
		    + currentUser.getId();
	    res = meetingService.listByCustomSQL(hql);
	} else if (currentUser.hasRole("Teacher")) {
	    List<Integer> userIds = new ArrayList<Integer>();
	    for (Classroom classroom : currentUser.getTeacherClassrooms()) {
		for (User u : classroom.getStudents()) {
		    userIds.add(u.getId());
		}
	    }
	    if (userIds.size() > 0) {
		String hql = "Select DISTINCT m FROM Meeting m JOIN m.meetingUsers mu WHERE mu.user.id IN ("
			+ StringUtils.join(userIds, ", ") + ")";
		res = meetingService.listByCustomSQL(hql);
	    }
	} else if (currentUser.hasRole("Parent")) {
	    List<Integer> userIds = new ArrayList<Integer>();
	    for (User u : currentUser.getChildren()) {
		userIds.add(u.getId());
	    }

	    if (userIds.size() > 0) {
		String hql = "Select DISTINCT m FROM Meeting m JOIN m.meetingUsers mu WHERE mu.user.id IN ("
			+ StringUtils.join(userIds, ", ") + ")";
		res = meetingService.listByCustomSQL(hql);
	    }
	    for (Meeting meeting : res) {
		if (!meeting.isApprove()) {
		    // check if parent has approved his own children
		    for (MeetingUser mu : meeting.getMeetingUsers()) {
			if (currentUser.getChildren().contains(mu.getUser())) {
			    meeting.setApprove(mu.getApprovedBy() != null);
			    break;
			}
		    }
		}
	    }

	}

	for(Meeting meeting: res) {
	    fillBBBMeetingInfo(meeting);
	}
	return res;
    }

    public void deleteMeeting(Meeting meeting) {
	User currentUser = userContext.getCurrentUser();
	Meeting persistentMeeting = meetingService.retrieveById(meeting.getId());
	if (currentUser.hasRole("Admin")) {
	    for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		meetingUserService.delete(mu);
	    }
	    meetingService.delete(persistentMeeting);
	} else if (currentUser.hasRole("Teacher")) {
	    if (persistentMeeting.getCreatedBy().getId().intValue() == currentUser.getId().intValue()) {
		// if meeting is created by the teacher then delete it
		for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		    meetingUserService.delete(mu);
		}
		meetingService.delete(persistentMeeting);
	    } else {
		// Delete all teacher's students that are participating in the
		// meeting
		ArrayList<MeetingUser> meetingUsersToDelete = new ArrayList<MeetingUser>();
		for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		    boolean isInTeeachersClassroom = false;
		    for (Classroom classroom : mu.getUser().getClassrooms()) {
			if (currentUser.getTeacherClassrooms().contains(classroom)) {
			    isInTeeachersClassroom = true;
			    break;
			}
		    }
		    if (isInTeeachersClassroom) {
			meetingUsersToDelete.add(mu);
		    }
		}
		for (MeetingUser mu : meetingUsersToDelete) {
		    meetingUserService.delete(mu);
		    persistentMeeting.getMeetingUsers().remove(mu);
		}

		if (meetingUsersToDelete.size() > 0) {
		    if (persistentMeeting.getMeetingUsers().size() == 0) {
			meetingService.delete(persistentMeeting);
		    }
		}
	    }
	} else if (currentUser.hasRole("Student")) {
	    for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		if (mu.getUser().getId().intValue() == currentUser.getId().intValue()) {
		    meetingUserService.delete(mu);
		    break;
		}
	    }
	}
    }

    public void updateMeeting(Meeting meeting) {
	boolean now = meeting.getTime() == null;
	if (now) {
	    meeting.setTime(new Date());
	}
	User currentUser = userContext.getCurrentUser();
	Set<User> pendingUsers = new HashSet<User>(meeting.getUsers());

	if (meeting.getId() == null && (currentUser.hasRole("Teacher") || currentUser.hasRole("Student"))) {
	    if (currentUser.hasRole("Admin") || currentUser.hasRole("Teacher")) {
		if (meeting.isApprove()) {
		    meeting.setApprovedBy(currentUser);
		} else {
		    meeting.setApprovedBy(null);
		}
	    }
	    meeting.setCreatedBy(currentUser);
	    meeting.setModeratorPassword(UUID.randomUUID().toString().replace("-", ""));
	    meeting.setUserPassword(UUID.randomUUID().toString().replace("-", ""));
	    meetingService.create(meeting);
	    for (User u : pendingUsers) {
		MeetingUser mu = new MeetingUser(new MeetingUserId(meeting.getId(), u.getId()), meeting, u);
		if(u.isAutoApproveUnattendedMeetings()) {
		    mu.setApprovedBy(userService.listByProperty("username", "admin").get(0));
		}
		meetingUserService.create(mu);
	    }
	} else {
	    Meeting persistentMeeting = meetingService.retrieveById(meeting.getId());
	    if (persistentMeeting.isApprove() && !meeting.isApprove()) {
		if (currentUser.hasRole("Admin") || currentUser.hasRole("Teacher")) {
		    meeting.setApprovedBy(null);
		}
	    } else if (!persistentMeeting.isApprove() && meeting.isApprove()) {
		if (currentUser.hasRole("Admin") || currentUser.hasRole("Teacher")) {
		    meeting.setApprovedBy(currentUser);
		}
	    }

	    persistentMeeting.setName(meeting.getName());
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
		if(u.isAutoApproveUnattendedMeetings()) {
		    mu.setApprovedBy(userService.listByProperty("username", "admin").get(0));
		}
		meetingUserService.create(mu);
	    }

	    if (currentUser.hasRole("Parent")) {
		// if (persistentMeeting.isApprove() != meeting.isApprove()) {
		for (MeetingUser mu : persistentMeeting.getMeetingUsers()) {
		    if (currentUser.getChildren().contains(mu.getUser())) {
			mu.setApprovedBy(meeting.isApprove() ? currentUser : null);
			meetingUserService.update(mu);
		    }
		}
	    }
	    // }

	}
    }

}
