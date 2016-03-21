package gr.ictpro.mall.flex;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Calendar;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Schedule;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;

import org.springframework.beans.factory.annotation.Autowired;

public class CalendarRemoteService {
    @Autowired(required = true)
    private GenericService<Calendar, Integer> calendarService;

    @Autowired(required = true)
    private GenericService<Schedule, Integer> scheduleService;

    @Autowired(required = true)
    private GenericService<Classroom, Integer> classroomService;

    @Autowired(required = true)
    private GenericService<User, Integer> userService;

    
    @Autowired(required = true)
    private UserContext userContext;

    public Calendar getCalendar(ASObject userObject) {
	int id = (Integer) userObject.get("id");
	Calendar c = calendarService.retrieveById(id);

	return c;
    }

    public List<Calendar> getCalendars() {
	User currentUser = userContext.getCurrentUser();
	
	List<Calendar> res = new ArrayList<Calendar>();
	
	for(Calendar calendar:currentUser.getCalendars()) {
	    res.add(calendar);
	}
	
	for(Classroom classroom:currentUser.getClassrooms()) {
	    for(Calendar calendar: classroom.getCalendars()) {
		res.add(calendar);
	    }
	}
	
	if (currentUser.hasRole("Teacher")) {
	    for (Classroom classroom : currentUser.getTeacherClassrooms()) {
		for (Calendar calendar : classroom.getCalendars()) {
		    res.add(calendar);
		}
	    }
	}	
	
	Collections.sort(res);
	return res;
    }

    public void updateCalendar(Calendar calendar) {
	//TODO: handle masterCalendar
	if (calendar.getClassroom() != null) {
	    calendar.setClassroom(classroomService.retrieveById(calendar.getClassroom().getId()));
	}
	if (calendar.getUser() != null) {
	    calendar.setUser(userService.retrieveById(calendar.getUser().getId()));
	}

	
	if(calendar.getId() == null) {
	    calendarService.create(calendar);
	} else {
	    Calendar persistentCalendar = calendarService.retrieveById(calendar.getId());
	    persistentCalendar.setClassroom(calendar.getClassroom());
	    persistentCalendar.setDescription(calendar.getDescription());
	    persistentCalendar.setEndTime(calendar.getEndTime());
	    persistentCalendar.setStartTime(calendar.getStartTime());
	    persistentCalendar.setUser(calendar.getUser());
	    calendarService.update(persistentCalendar);
	    
	}
    }

    public void deleteCalendar(Calendar calendar) {
	Calendar persistenCalendar = calendarService.retrieveById(calendar.getId());
	calendarService.delete(persistenCalendar);
    }

    public void updateSchedule(Schedule schedule) {
	if (schedule.getClassroom() != null) {
	    schedule.setClassroom(classroomService.retrieveById(schedule.getClassroom().getId()));
	}
	if (schedule.getUser() != null) {
	    schedule.setUser(userService.retrieveById(schedule.getUser().getId()));
	}

	if(schedule.getId() == null) {
	    scheduleService.create(schedule);
	} else {
	    Schedule persistentSchedule = scheduleService.retrieveById(schedule.getId());
	    deleteCalendarEntries(persistentSchedule);
	    persistentSchedule.setDescription(schedule.getDescription());
	    persistentSchedule.setDay(schedule.getDay());
	    persistentSchedule.setEndTime(schedule.getEndTime());
	    persistentSchedule.setRepeatEvery(schedule.getRepeatEvery());
	    persistentSchedule.setRepeatInterval(schedule.getRepeatInterval());
	    persistentSchedule.setRepeatUntil(schedule.getRepeatUntil());
	    persistentSchedule.setStartTime(schedule.getStartTime());
	    scheduleService.update(persistentSchedule);
	    generateCalendarEntries(persistentSchedule);
	}
	
	
	generateCalendarEntries(schedule);
    }

    public void deleteSchedule(Schedule schedule) {
	Schedule persistentSchedule = scheduleService.retrieveById(schedule.getId());
	deleteCalendarEntries(persistentSchedule);
	scheduleService.delete(persistentSchedule);
    }

    private void generateCalendarEntries(Schedule schedule) {
	Date currentDate = new Date(schedule.getStartTime().getTime());
	Date endDate = new Date(schedule.getRepeatUntil().getTime());
	
	long duration = schedule.getEndTime().getTime() - currentDate.getTime();
	long interval = schedule.getRepeatInterval()*7*24*60*60*1000;
	
	java.util.Calendar cal = java.util.Calendar.getInstance();
	cal.setTime(currentDate);
	int day = cal.get(java.util.Calendar.DAY_OF_WEEK) -cal.getFirstDayOfWeek();
	if(day<schedule.getDay()) {
	    currentDate.setTime(currentDate.getTime()+ 24*60*60*1000*(schedule.getDay() - day));
	}
	int dstOffset = cal.get(java.util.Calendar.DST_OFFSET);
	
	do {
	    Calendar calendar = new Calendar();
	    cal.setTime(currentDate);
	    calendar.setStartTime(new Date(currentDate.getTime()));
	    calendar.setClassroom(schedule.getClassroom());
	    calendar.setDescription(schedule.getDescription());
	    calendar.setEndTime(new Date(currentDate.getTime() + duration));
	    calendar.setSchedule(schedule);
	    calendar.setUser(schedule.getUser());
	    currentDate.setTime(currentDate.getTime()+interval);
	    int currentDstOffset = cal.get(java.util.Calendar.DST_OFFSET);
	    if(currentDstOffset != dstOffset) {
		int applyOffset = currentDstOffset == 0? -dstOffset:currentDstOffset; 
		currentDate.setTime(currentDate.getTime() - applyOffset);
		calendar.setStartTime(new Date(calendar.getStartTime().getTime() - applyOffset));
		calendar.setEndTime(new Date(calendar.getEndTime().getTime() - applyOffset));
		dstOffset = currentDstOffset;
	    }
	    calendarService.create(calendar);
	} while (currentDate.compareTo(endDate) < 0);
	
    }
    
    private void deleteCalendarEntries(Schedule schedule) {
	for(Calendar calendar: schedule.getCalendarEntries()) {
	    calendarService.delete(calendar);
	}
    }

}
