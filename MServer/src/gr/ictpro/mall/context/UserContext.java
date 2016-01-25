/**
 * 
 */
package gr.ictpro.mall.context;

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
    private UserService userService;

    public User getCurrentUser() {
	User u = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	return userService.retrieveById(u.getId());	
    }
    
    public Language getUserLang(User u) {
	return languageService.listByProperty("code", "en").get(0); 
    }
    
    public Classroom getCurrentClassroom(User u) {
	//TODO:
	return null; 
    }

}
