package gr.ictpro.mall.flex;

import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.Classroomgroup;
import gr.ictpro.mall.model.Course;
import gr.ictpro.mall.model.CourseTemplate;
import gr.ictpro.mall.model.Project;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

public class CourseRemoteService {
    @Autowired(required = true)
    private GenericService<CourseTemplate, Integer> courseTemplateService;

    @Autowired(required = true)
    private GenericService<Course, Integer> courseService;
    
    @Autowired(required = true)
    private UserContext userContext;

    public List<CourseTemplate> getCourseTemplates() {
	return courseTemplateService.listAll();
    }

    public void updateCourseTemplate(CourseTemplate courseTemplate) {
	if (courseTemplate.getId() == null) {
	    courseTemplateService.create(courseTemplate);
	} else {
	    CourseTemplate persistentCourseTemplate = courseTemplateService.retrieveById(courseTemplate.getId());
	    persistentCourseTemplate.setMoodleId(courseTemplate.getMoodleId());
	    persistentCourseTemplate.setName(courseTemplate.getName());
	    courseTemplateService.update(persistentCourseTemplate);
	}
    }

    public void deleteCourseTemplate(CourseTemplate courseTemplate) {
	CourseTemplate persistentCourseTemplate = courseTemplateService.retrieveById(courseTemplate.getId());
	courseTemplateService.delete(persistentCourseTemplate);
    }

    public List<Course> getCourses() {
	List<Course> res = null;
	User currentUser = userContext.getCurrentUser();
	if(currentUser.hasRole("Admin")) {
	    res = courseService.listAll();
	} else if(currentUser.hasRole("Teacher")) {
	    res = new ArrayList<Course>();
	    for(Classroom c:currentUser.getTeacherClassrooms()) {
		res.addAll(c.getCourses());
		for(Classroomgroup cg:c.getClassroomgroups()) {
		    res.addAll(cg.getCourses());
		}
	    }
	    for(Project p:currentUser.getProjects()) {
		res.addAll(p.getCourses());
	    }
	} else if(currentUser.hasRole("Student")) {
	    res = new ArrayList<Course>();
	    for(Classroom c:currentUser.getClassrooms()) {
		res.addAll(c.getCourses());
		for(Classroomgroup cg:c.getClassroomgroups()) {
		    res.addAll(cg.getCourses());
		}
	    }
	    for(Project p:currentUser.getProjects()) {
		res.addAll(p.getCourses());
	    }
	}
	
	return res; 
    }

    public void updateCourse(Course course) {
	if (course.getId() == null) {
	    courseService.create(course);
	} else {
	    Course persistentCourse = courseService.retrieveById(course.getId());
	    persistentCourse.setClassroom(course.getClassroom());
	    persistentCourse.setClassroomgroup(course.getClassroomgroup());
	    persistentCourse.setProject(course.getProject());
	    courseService.update(persistentCourse);
	}
    }

    public void deleteCourse(Course course) {
	Course persistentCourse = courseService.retrieveById(course.getId());
	courseService.delete(persistentCourse);
    }

}
