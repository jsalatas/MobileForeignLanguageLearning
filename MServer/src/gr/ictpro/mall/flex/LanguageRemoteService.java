/**
 * 
 */
package gr.ictpro.mall.flex;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.service.GenericService;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class LanguageRemoteService {
    @Autowired(required = true)
    private GenericService<Language, String> languageService;

    public List<Language> getLanguages() {
	return languageService.listAll();
    }

    public void updateLanguage(ASObject persistentData) {
	String code = (String) persistentData.get("code");
	String englishName = (String) persistentData.get("englishName");
	String localName = (String) persistentData.get("localName");
	Language l = languageService.retrieveById(code);
	if(l == null) {
	    l = new Language(code, englishName, localName);
	    languageService.create(l);
	} else {
	    l.setEnglishName(englishName);
	    l.setLocalName(localName);
	    languageService.update(l);
	}
    }

    public void deleteLanguage(ASObject persistentData) {
	String code = (String) persistentData.get("code");
	languageService.delete(code);
    }
}
