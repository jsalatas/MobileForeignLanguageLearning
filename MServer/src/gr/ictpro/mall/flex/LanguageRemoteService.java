/**
 * 
 */
package gr.ictpro.mall.flex;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.transform.TransformerException;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Hibernate;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.EmailTranslation;
import gr.ictpro.mall.model.EnglishEmail;
import gr.ictpro.mall.model.EnglishText;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Translation;
import gr.ictpro.mall.service.GenericService;
import gr.ictpro.mall.utils.TranslationsXMLUtils;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class LanguageRemoteService {
    @Autowired(required = true)
    private GenericService<Language, String> languageService;

    @Autowired(required = true)
    private GenericService<EnglishText, Integer> englishTextService; 

    @Autowired(required = true)
    private GenericService<EnglishEmail, Integer> englishEmailService;
    
    public List<Language> getLanguages() {
	return languageService.listAll();
    }

    public void updateLanguage(ASObject langObj) {
	String code = (String) langObj.get("code");
	String englishName = (String) langObj.get("englishName");
	String localName = (String) langObj.get("localName");
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

    public void deleteLanguage(ASObject langObj) {
	String code = (String) langObj.get("code");
	languageService.delete(code);
    }
    
    public String getTranslationsXML(ASObject translObj) throws TransformerException {
	String languageCode = (String) translObj.get("language_code");
	Boolean untranslatedOnly = (Boolean) translObj.get("untranslated");
	
	// Get translations
	List<Translation> translations = new ArrayList<Translation>();
	List<Integer> translationIds = new ArrayList<Integer>();
	Language language = languageService.retrieveById(languageCode);
	Hibernate.initialize(language.getTranslations());
	for(Translation t: language.getTranslations()) {
	    if(!untranslatedOnly) {
		translations.add(t);
	    }
	    translationIds.add(t.getEnglishText().getId());
	}
	List<EnglishText> englishTexts;
	if(translationIds.size() == 0) {
	    englishTexts = englishTextService.listAll();
	} else {
	    englishTexts = englishTextService.listByCustomSQL("FROM EnglishText WHERE id NOT IN ("+StringUtils.join(translationIds, ", ")+")");
	}
	
	// Get emails
	List<EmailTranslation> emails = new ArrayList<EmailTranslation>();
	List<Integer> emailIds = new ArrayList<Integer>();
	Hibernate.initialize(language.getEmailTranslations());
	for(EmailTranslation e: language.getEmailTranslations()) {
	    if(!untranslatedOnly) {
		emails.add(e);
	    }
	    emailIds.add(e.getId());
	    
	}
	
	List<EnglishEmail> englishEmails;
	if(emailIds.size() == 0) {
	    englishEmails = englishEmailService.listAll();
	} else {
	    englishEmails = englishEmailService.listByCustomSQL("FROM EnglishEmail WHERE id NOT IN ("+StringUtils.join(translationIds, ", ")+")");
	}
	
	String res;
	
	if(untranslatedOnly) {
	    res = TranslationsXMLUtils.getXML(language, null, englishTexts, englishEmails);
	} else {
	    res = TranslationsXMLUtils.getXML(language, null, translations, emails, englishTexts, englishEmails);
	}
	

	return res;
    }

    public void updateTranslations(String xml) {
	System.err.println(xml);
	
    }
}
