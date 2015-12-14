/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Role;
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
    private UserService userService;

    @Autowired(required = true)
    private GenericService<Language, String> languageService;

    @Autowired(required = true)
    private UserContext userContext;

    public List<Classroom> getClassrooms() {
	User currentUser = userContext.getCurrentUser(); 
	if(currentUser.hasRole("Teacher")) {
	    // get only user's languages
	   Hibernate.initialize(currentUser.getClassrooms());
	   return new ArrayList<Classroom>(currentUser.getClassrooms());
	}
	System.err.println(classroomService.listAll().size());
	return classroomService.listAll();
    }

    public void deleteClassroom(ASObject classroomObj) {
	Integer id = (Integer)classroomObj.get("classroom_id");
	
	User currentUser = userContext.getCurrentUser();
	
	if(currentUser.hasRole("Admin")) {
	    classroomService.delete(id);
	} else {
	    // A teacher can only delete her own classrooms 
	    Classroom c = classroomService.retrieveById(id);
	    Hibernate.initialize(c.getUsers()); 
	    if(c.getUsers().contains(currentUser)) {
		classroomService.delete(id);
	    }
	}
    }

    public void updateClassroom(ASObject classroomObj) {
	Integer id = -1;
	if(classroomObj.containsKey("id")) {
	    id = (Integer)classroomObj.get("id");
	}
	
	String name = (String)classroomObj.get("name");
	String notes = (String)classroomObj.get("notes");
	String languageCode = (String)classroomObj.get("language_code");
	
	Language language = languageService.retrieveById(languageCode);
	
	User teacher;
	User currentUser = userContext.getCurrentUser();
	if(currentUser.hasRole("Admin")) {
	    Integer teacherId = (Integer)classroomObj.get("teacher_id");
	    teacher = userService.retrieveById(teacherId);
	} else {
	    teacher = currentUser;
	}
	
	Classroom c; 
	if(id == -1) {
	    c = new Classroom(name);
	    c.setNotes(notes);
	    Set<User> users = new HashSet<User>();
	    users.add(teacher);
	    c.setUsers(users);
	    c.setLanguage(language);
	    classroomService.create(c);
	} else {
	    c = classroomService.retrieveById(id);
	    c.setName(name);
	    c.setNotes(notes);
	    classroomService.replaceTeacher(c, teacher);
	    c.setLanguage(language);
	    classroomService.update(c);
	}
    }

}
