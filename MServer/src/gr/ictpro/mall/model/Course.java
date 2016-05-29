package gr.ictpro.mall.model;

// Generated May 18, 2016 12:03:49 AM by Hibernate Tools 4.0.0

import gr.ictpro.mall.interceptors.ClientReferenceClass;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * Course generated by hbm2java
 */
@Entity
@Table(name = "course")
@ClientReferenceClass(className="gr.ictpro.mall.client.model.vo.Course")
public class Course implements java.io.Serializable {

    private Integer id;
    private String name;
    private CourseTemplate courseTemplate;
    private Classroom classroom;
    private Classroomgroup classroomgroup;
    private Project project;

    public Course() {
    }

    public Course(CourseTemplate courseTemplate, String name) {
	this.courseTemplate = courseTemplate;
	this.name = name;
    }

    public Course(CourseTemplate courseTemplate, Classroom classroom, Classroomgroup classroomgroup, Project project) {
	this.courseTemplate = courseTemplate;
	this.classroom = classroom;
	this.classroomgroup = classroomgroup;
	this.project = project;
    }

    @Id
    @GeneratedValue(strategy = IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    public Integer getId() {
	return this.id;
    }

    public void setId(Integer id) {
	this.id = id;
    }

    @Column(name = "name", nullable = false, length = 50)
    public String getName() {
	return this.name;
    }

    public void setName(String name) {
	this.name = name;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "template_id", nullable = false)
    public CourseTemplate getCourseTemplate() {
	return this.courseTemplate;
    }

    public void setCourseTemplate(CourseTemplate courseTemplate) {
	this.courseTemplate = courseTemplate;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "classroom_id")
    public Classroom getClassroom() {
	return this.classroom;
    }

    public void setClassroom(Classroom classroom) {
	this.classroom = classroom;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "clasroomgroup_id")
    public Classroomgroup getClassroomgroup() {
	return this.classroomgroup;
    }

    public void setClassroomgroup(Classroomgroup classroomgroup) {
	this.classroomgroup = classroomgroup;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "project_id")
    public Project getProject() {
	return this.project;
    }

    public void setProject(Project project) {
	this.project = project;
    }

}
