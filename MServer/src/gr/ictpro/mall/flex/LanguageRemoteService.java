/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.List;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.service.LanguageService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class LanguageRemoteService {
    private LanguageService languageService;

    public void setLanguageService(LanguageService languageService) {
        this.languageService = languageService;
    }

    public List<Language> getLanguages() {
	return languageService.listAll();
    }
    
    public void updateLanguages(ASObject lang) {
	//TODO: implement method
    }
}
