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
import org.springframework.beans.factory.annotation.Autowired;
import org.xml.sax.SAXException;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.context.UserContext;
import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.EmailTranslation;
import gr.ictpro.mall.model.EmailTranslationId;
import gr.ictpro.mall.model.EnglishEmail;
import gr.ictpro.mall.model.EnglishText;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Translation;
import gr.ictpro.mall.model.TranslationId;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.service.ClassroomService;
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
    
    @Autowired(required = true)
    private ClassroomService classroomService;

    @Autowired(required = true)
    private UserContext userContext;

    public List<Language> getLanguages() {
	return languageService.listAll();
    }

    public void updateLanguage(Language language) {
	Language l = languageService.retrieveById(language.getCode());
	if(l == null) {
	    languageService.create(language);
	} else {
	    Language persistentLanguage = languageService.retrieveById(language.getCode());
	    persistentLanguage.setLocalName(language.getLocalName());
	    persistentLanguage.setEnglishName(language.getEnglishName());
	    languageService.update(persistentLanguage);
	}
    }

    public void deleteLanguage(Language language) {
	languageService.delete(languageService.retrieveById(language.getCode()));
    }
    
    public String getTranslationsXML(ASObject translObj) throws TransformerException {
	String languageCode = (String) translObj.get("language_code");
	Integer classroomId = (Integer) translObj.get("classroom_id");
	
	if(classroomId == null) {
	    classroomId = 0;
	}
	Classroom classroom = classroomService.retrieveById(classroomId);	
	
	if(languageCode == null) {
	    languageCode = classroom.getLanguage().getCode();
	}
	Language language = languageService.retrieveById(languageCode);
		
	Boolean untranslatedOnly = (Boolean) translObj.get("untranslated");
	
	String translationsHQL = "FROM Translation WHERE (language.code = '"+languageCode+"' AND classroom.id = "+classroomId+")";
	String emailTranslationsHQL = "FROM EmailTranslation WHERE (language.code = '"+languageCode+"' AND classroom.id = "+classroomId+")";
	if(classroomId.intValue() != 0) {
	    translationsHQL = translationsHQL + " OR (language.code = '"+languageCode+"' AND classroom.id = 0 AND englishText.id NOT IN (SELECT  englishText.id FROM Translation WHERE language.code = '"+languageCode+"' AND classroom.id = "+classroomId+"))";
	    emailTranslationsHQL = emailTranslationsHQL + " OR (language.code = '"+languageCode+"' AND classroom.id = 0 AND englishEmail.emailType NOT IN (SELECT englishEmail.emailType FROM EmailTranslation WHERE language.code = '"+languageCode+"' AND classroom.id = "+classroomId+"))";
	}
	
	// Get translations
	List<Translation> translations = new ArrayList<Translation>();
	List<Integer> translationIds = new ArrayList<Integer>();
	List<Translation> allTanslations = translationService.listByCustomSQL(translationsHQL);
	for(Translation t: allTanslations) {
	    if(!untranslatedOnly.booleanValue()) {
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
	List<EmailTranslation> allEmails = emailTranslationService.listByCustomSQL(emailTranslationsHQL);
	for(EmailTranslation e: allEmails) {
	    if(!untranslatedOnly) {
		emails.add(e);
	    }
	    emailIds.add(e.getId().getEmailType().ordinal());
	    
	}
	
	List<EnglishEmail> englishEmails;
	if(emailIds.size() == 0) {
	    englishEmails = englishEmailService.listAll();
	} else {
	    englishEmails = englishEmailService.listByCustomSQL("FROM EnglishEmail WHERE emailType NOT IN ("+StringUtils.join(emailIds, ", ")+")");
	}
	
	String res;
	
	if(untranslatedOnly) {
	    res = TranslationsXMLUtils.getXML(language, classroom, englishTexts, englishEmails);
	} else {
	    res = TranslationsXMLUtils.getXML(language, classroom, translations, emails, englishTexts, englishEmails);
	}
	

	return res;
    }

    @SuppressWarnings("unchecked")
    public void updateTranslations(String xml) throws SecurityException {
	try {
	    Map<String, Object> parsedObjects = TranslationsXMLUtils.parseXML(xml);
	    
	    User currentUser = userContext.getCurrentUser(); 
	    if(!currentUser.hasRole("Admin")) {
		Classroom classroom = (Classroom)parsedObjects.get("classroom");
		if(classroom == null || classroom.getTeacher().getId().intValue() != currentUser.getId().intValue()) {
		    throw new SecurityException("Teachers can update translations only for their classrooms");
		}
	    }
	    
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
