/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Classroomgroup;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.ClassroomService;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.service.UserService;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class ClassroomRemoteService {
    @Autowired(required = true)
    private ClassroomService classroomService;

    @Autowired(required = true)
    private GenericService<Classroomgroup, Integer> classroomgroupService;

    @Autowired(required = true)
    private UserService userService;

    @Autowired(required = true)
    private GenericService<Language, String> languageService;

    @Autowired(required = true)
    private UserContext userContext;

    public List<Classroom> getClassrooms() {
	ArrayList<Classroom> res = null;
	User currentUser = userContext.getCurrentUser();
	if (currentUser.hasRole("Admin")) {
	    res = new ArrayList<Classroom>(classroomService.listAll());
	} else if (currentUser.hasRole("Teacher")) {
	    // get only user's languages
	    Hibernate.initialize(currentUser.getClassrooms());
	    res = new ArrayList<Classroom>(currentUser.getClassrooms());
	}
	return res;
    }

    public void deleteClassroom(Classroom classroom) {
	User currentUser = userContext.getCurrentUser();

	Classroom persistentClassroom = classroomService.retrieveById(classroom.getId());
	if (currentUser.hasRole("Admin")) {
	    classroomService.delete(persistentClassroom);
	} else {
	    // A teacher can only delete her own classrooms
	    if (persistentClassroom.getUsers().contains(currentUser)) {
		classroomService.delete(persistentClassroom);
	    }
	}
    }

    public void updateClassroom(Classroom classroom) {
	classroom.setLanguage(languageService.retrieveById(classroom.getLanguage().getCode()));
	Set<User> users = new HashSet<User>();
//	for (User u : classroom.getUsers()) {
//	    users.add(userService.retrieveById(u.getId()));
//	}
//	classroom.setUsers(users);
//
//	if (classroom.getClassroomgroups() == null) {
//	    classroom.setClassroomgroups(new HashSet<Classroomgroup>(0));
//	}
//
//	Set<Classroomgroup> classroomgroups = new HashSet<Classroomgroup>();
//	for (Classroomgroup c : classroom.getClassroomgroups()) {
//	    classroomgroups.add(classroomgroupService.retrieveById(c.getId()));
//	}
//	classroom.setClassroomgroups(classroomgroups);
//
	if (classroom.getId() == null) {
	    classroomService.create(classroom);
	} else {
	    Classroom persistentClassroom = classroomService.retrieveById(classroom.getId());
	    persistentClassroom.setName(classroom.getName());
	    persistentClassroom.setNotes(classroom.getNotes());
	    persistentClassroom.setLanguage(classroom.getLanguage());
	    persistentClassroom.setUsers(users);

	    classroomService.update(persistentClassroom);

	    User teacher;
	    User currentUser = userContext.getCurrentUser();
	    if (currentUser.hasRole("Admin") && classroom.getTeacher() != null) {
		teacher = userService.retrieveById(classroom.getTeacher().getId());
	    } else {
		teacher = userService.retrieveById(currentUser.getId());
	    }

	    classroomService.replaceTeacher(persistentClassroom, teacher);
	}
    }

    public List<Classroomgroup> getClassroomgroups() {
	return classroomgroupService.listAll();
    }

    public void updateClassroomgroup(Classroomgroup classroomgroup) {
	if (classroomgroup.getId() == 0) {
	    classroomgroupService.create(classroomgroup);
	} else {
	    Classroomgroup persistentClassroomgroup = classroomgroupService.retrieveById(classroomgroup.getId());
	    persistentClassroomgroup.setName(classroomgroup.getName());
	    persistentClassroomgroup.setNotes(classroomgroup.getNotes());

	    classroomgroupService.update(persistentClassroomgroup);
	}
    }

    public void deleteClassroomgroup(Classroomgroup classroomgroup) {
	classroomgroupService.delete(classroomgroupService.retrieveById(classroomgroup.getId()));
    }

}
