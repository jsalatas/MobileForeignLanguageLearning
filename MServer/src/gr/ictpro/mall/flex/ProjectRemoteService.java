package gr.ictpro.mall.flex;

import gr.ictpro.mall.model.Course;
import gr.ictpro.mall.model.Project;
import gr.ictpro.mall.service.GenericService;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

public class ProjectRemoteService {
    @Autowired(required = true)
    private GenericService<Project, Integer> projectService;


    public List<Project> getProjects() {
	return projectService.listAll();
    }

    public void updateProject(Project project) {
	if (project.getId() == null) {
	    projectService.create(project);
	} else {
	    Project persistentProject = projectService.retrieveById(project.getId());
	    persistentProject.setName(project.getName());
	    persistentProject.setNotes(project.getNotes());
	    persistentProject.setUsers(project.getUsers());
	    projectService.update(persistentProject);
	}
    }

    public void deleteProject(Project project) {
	Project persistentProject = projectService.retrieveById(project.getId());
	projectService.delete(persistentProject);
    }
    
}
