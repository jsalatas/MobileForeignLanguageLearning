/**
 * 
 */
package gr.ictpro.mall.flex;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.service.GenericService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class LanguageRemoteService {
    @Autowired(required = true)
    private GenericService<Language, Integer> languageService;

    public List<Language> getLanguages() {
	return languageService.listAll();
    }
}
