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

    @SuppressWarnings("unchecked")
    public void updateLanguages(ASObject persistentData) {
	ArrayList<ASObject> languages = (ArrayList<ASObject>) persistentData.get("languages");
	String codes=""; 
	for (ASObject language : languages) {
	    String code = (String) language.get("code");
	    if(!codes.equals("")) {
		codes += ", ";
	    }
	    codes +="'"+code+"'";
	    if (!code.equals("en")) {
		String englishName = (String) language.get("englishName");
		String localName = (String) language.get("localName");
		Language l = languageService.retrieveById(code);
		if (l == null) {
		    l = new Language(code, englishName, localName);
		    languageService.create(l);
		} else {
		    l.setEnglishName(englishName);
		    l.setLocalName(localName);
		    languageService.update(l);
		}
	    }
	}
	
	languageService.execSQL("delete Language where code not in ("+codes+")");
	
    }
}
