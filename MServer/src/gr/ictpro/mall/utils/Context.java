/**
 * 
 */
package gr.ictpro.mall.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import gr.ictpro.mall.model.Email;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.GenericService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Component
public class Context {
    @Autowired(required = true)
    private GenericService<Language, Integer> languageService;

    public Language getUserLang(User u) {
	return languageService.listByProperty("code", "en").get(0); 
    }
}
