/**
 * 
 */
package gr.ictpro.mall.flex;


import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Hibernate;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.xml.sax.SAXException;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.EmailTranslation;
import gr.ictpro.mall.model.EmailTranslationId;
import gr.ictpro.mall.model.EmailType;
import gr.ictpro.mall.model.EnglishEmail;
import gr.ictpro.mall.model.EnglishText;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Translation;
import gr.ictpro.mall.model.TranslationId;
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
    private GenericService<Translation, TranslationId> translationService;

    @Autowired(required = true)
    private GenericService<EmailTranslation, EmailTranslationId> emailTranslationService;

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
	    emailIds.add(e.getId().getEmailType().ordinal());
	    
	}
	
	List<EnglishEmail> englishEmails;
	if(emailIds.size() == 0) {
	    englishEmails = englishEmailService.listAll();
	} else {
	    englishEmails = englishEmailService.listByCustomSQL("FROM EnglishEmail WHERE id.emailType NOT IN ("+StringUtils.join(emailIds, ", ")+")");
	}
	
	String res;
	
	if(untranslatedOnly) {
	    res = TranslationsXMLUtils.getXML(language, null, englishTexts, englishEmails);
	} else {
	    res = TranslationsXMLUtils.getXML(language, null, translations, emails, englishTexts, englishEmails);
	}
	

	return res;
    }

    @SuppressWarnings("unchecked")
    public void updateTranslations(String xml) {
	try {
	    Map<String, Object> parsedObjects = TranslationsXMLUtils.parseXML(xml);
	    List<Translation> translations = (List<Translation>) parsedObjects.get("translations");
	    List<EmailTranslation> emails = (List<EmailTranslation>) parsedObjects.get("emailTranslations");
	    if(translations != null) {
		for(Translation t:translations) {
		    Translation existing = translationService.retrieveById(t.getId());
		    if(existing == null) {
			translationService.create(t);
		    } else {
			existing.setTranslatedText(t.getTranslatedText());
			translationService.update(existing);
		    }
		}
	    }
	    if(emails != null) {
		for(EmailTranslation e:emails) {
		    EmailTranslation existing = emailTranslationService.retrieveById(e.getId());
		    if(existing == null) {
			emailTranslationService.create(e);
		    } else {
			existing.setBody(e.getBody());
			existing.setSubject(e.getSubject());
			emailTranslationService.update(existing);
		    }
		    
		}
	    }
	    
	} catch (ParserConfigurationException | SAXException | IOException e) {
	    e.printStackTrace();
	}
	
    }
}
