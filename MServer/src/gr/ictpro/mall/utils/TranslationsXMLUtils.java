/**
 * 
 */
package gr.ictpro.mall.utils;


import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.EmailTranslation;
import gr.ictpro.mall.model.EmailTranslationId;
import gr.ictpro.mall.model.EmailType;
import gr.ictpro.mall.model.EnglishEmail;
import gr.ictpro.mall.model.EnglishText;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Translation;
import gr.ictpro.mall.model.TranslationId;
import gr.ictpro.mall.service.GenericService;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoader;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class TranslationsXMLUtils {

    public static String getXML(Language language, Classroom classroom, List<EnglishText> englishTexts, List<EnglishEmail> englishEmails) throws TransformerException {
	return getXML(language, classroom, null, null, englishTexts, englishEmails);
    }

    public static String getXML(Language language, Classroom classroom, List<Translation> translations, List<EmailTranslation> emails, List<EnglishText> englishTexts, List<EnglishEmail> englishEmails) throws TransformerException {
	Document doc = createXMLDocument();

	Element rootElement = doc.createElement("root");
	doc.appendChild(rootElement);

	addLanguage(doc, language);
	addClassroom(doc, classroom);
	Element translationsElement = doc.createElement("translations");
	doc.getDocumentElement().appendChild(translationsElement);
	addTranslations(doc, translationsElement, translations, englishTexts);
	
	Element emailsElement = doc.createElement("emails");
	doc.getDocumentElement().appendChild(emailsElement);
	addEmailTranslations(doc, emailsElement, emails, englishEmails);

	return convertToString(doc);
    }

    @SuppressWarnings("unchecked")
    public static Map<String, Object> parseXML(String xml) throws ParserConfigurationException, SAXException, IOException {
	Map<String, Object> res = new LinkedHashMap<String, Object>();
	
	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	DocumentBuilder builder = factory.newDocumentBuilder();
	Document doc = builder.parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));
	
	Element root = doc.getDocumentElement();
	
	Language language = getLanguage(root);
	Classroom classroom = getClassroom(root);
	if(classroom == null) {
	    // Get master classroom
	    ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	    GenericService<Classroom, Integer> classroomService = (GenericService<Classroom, Integer>) ctx.getBean("classroomService");
	    classroom = classroomService.retrieveById(0);

	}
	
	List<Translation> translations = getTraslations(root, language, classroom);
	res.put("translations", translations);
	
	List<EmailTranslation> emailTranslations = getEmailTraslations(root, language, classroom);
	res.put("emailTranslations", emailTranslations);

	return res;
    }
    
    
    @SuppressWarnings("unchecked")
    private static List<EmailTranslation> getEmailTraslations(Element root, Language language, Classroom classroom) {
	List<EmailTranslation> emails = new ArrayList<EmailTranslation>();
	
	NodeList translationsNode = root.getElementsByTagName("emails");
	if(translationsNode.getLength() == 1) {
	    ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	    GenericService<EnglishEmail, Integer> englishEmailService = (GenericService<EnglishEmail, Integer>) ctx.getBean("englishEmailService");
	    
	    NodeList translationNodes = translationsNode.item(0).getChildNodes();
	    for(int i=0; i<translationNodes.getLength(); i++) {
		if(translationNodes.item(i) instanceof Element) {
		    Element tranlationElement = (Element)translationNodes.item(i);
		    EmailTranslation email = new EmailTranslation();
		    email.setLanguage(language);
		    email.setClassroom(classroom);
		    email.setSubject(((Element)tranlationElement.getElementsByTagName("subject").item(0)).getElementsByTagName("translatedText").item(0).getTextContent());
		    email.setBody(((Element)tranlationElement.getElementsByTagName("body").item(0)).getElementsByTagName("translatedText").item(0).getTextContent());
		    EnglishEmail englishEmail = englishEmailService.listByProperty("emailType", EmailType.valueOf(tranlationElement.getElementsByTagName("type").item(0).getTextContent())).get(0);
		    email.setEnglishEmail(englishEmail);
		    email.setId(new EmailTranslationId(language.getCode(), classroom.getId(), englishEmail.getEmailType()));
		    if(email.getSubject() != null && !email.getSubject().equals("") && email.getBody() != null && !email.getBody().equals("")) {
			emails.add(email);
		    }
		}
	    }
	}

	
	return emails;
    }

    @SuppressWarnings("unchecked")
    private static List<Translation> getTraslations(Element root, Language language, Classroom classroom) {
	List<Translation> translations = new ArrayList<Translation>();
	
	NodeList translationsNode = root.getElementsByTagName("translations");
	if(translationsNode.getLength() == 1) {
	    ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	    GenericService<EnglishText, Integer> englishTextService = (GenericService<EnglishText, Integer>) ctx.getBean("englishTextService");
	    
	    NodeList translationNodes = translationsNode.item(0).getChildNodes();
	    for(int i=0; i<translationNodes.getLength(); i++) {
		if(translationNodes.item(i) instanceof Element) {
		    Element tranlationElement = (Element)translationNodes.item(i);
		    Translation translation = new Translation();
		    translation.setLanguage(language);
		    translation.setClassroom(classroom);
		    translation.setTranslatedText(tranlationElement.getElementsByTagName("translatedText").item(0).getTextContent());
		    EnglishText englishText = englishTextService.listByProperty("englishText", tranlationElement.getElementsByTagName("originalText").item(0).getTextContent()).get(0);
		    translation.setEnglishText(englishText);
		    translation.setId(new TranslationId(englishText.getId(), language.getCode(), classroom.getId()));
		    if(translation.getTranslatedText() != null && !translation.getTranslatedText().equals("")) {
			translations.add(translation);
		    }
		}
	    }
	}

	return translations;
    }

    @SuppressWarnings("unchecked")
    private static Classroom getClassroom(Element root) {
	NodeList classroomNode = root.getElementsByTagName("classroom");
	Classroom classroom = null;
	if(classroomNode.getLength() == 1) {
	    Integer classroomId = Integer.parseInt(classroomNode.item(0).getTextContent());
	    ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	    GenericService<Classroom, Integer> classroomService = (GenericService<Classroom, Integer>) ctx.getBean("classroomService");
	    classroom = classroomService.retrieveById(classroomId);
	}
	return classroom;
    }

    @SuppressWarnings("unchecked")
    private static Language getLanguage(Element root) {
	NodeList languageNode = root.getElementsByTagName("language");
	Language language = null;
	if(languageNode.getLength() == 1) {
	    String languageCode =languageNode.item(0).getTextContent();
	    ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
	    GenericService<Language, String> languageService = (GenericService<Language, String>) ctx.getBean("languageService");
	    language = languageService.retrieveById(languageCode);
	}
	return language;
    }

    private static Document createXMLDocument() {
	Document doc = null;
	DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
	try {
	    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
	    doc = docBuilder.newDocument();	    
	} catch (ParserConfigurationException e) {
	    e.printStackTrace();
	}
	
	return doc;
    }
    
    private static void addLanguage(Document doc, Language language) {
	Element languageElement = doc.createElement("language");
	languageElement.appendChild(doc.createTextNode(language.getCode()));
	doc.getDocumentElement().appendChild(languageElement);
    }
    
    private static void addClassroom(Document doc, Classroom classroom) {
	Element languageElement = doc.createElement("classroom");
	if(classroom != null) {
	    languageElement.appendChild(doc.createTextNode(classroom.getName()));
	    doc.getDocumentElement().appendChild(languageElement);
	}
    }

    private static void addTranslations(Document doc, Element translationsElement, List<Translation> translations, List<EnglishText> englishTexts) {
	if(translations != null) {
	     for(Translation t: translations) {
		 Element translationElement = doc.createElement("translation");
		 translationsElement.appendChild(translationElement);
		 
		 Element idElement = doc.createElement("id");
		 idElement.appendChild(doc.createTextNode(Integer.toString(t.getId().getEnglishTextId())));
		 translationElement.appendChild(idElement);

		 Element originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(t.getEnglishText().getEnglishText()));
		 translationElement.appendChild(originalTextElement);

		 Element translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(t.getTranslatedText()));
		 translationElement.appendChild(translatedTextElement);
	     }
	}
	
	if(englishTexts != null) {
	     for(EnglishText e: englishTexts) {
		 Element translationElement = doc.createElement("translation");
		 translationsElement.appendChild(translationElement);
		 
		 Element idElement = doc.createElement("id");
		 idElement.appendChild(doc.createTextNode(Integer.toString(e.getId())));
		 translationElement.appendChild(idElement);

		 Element originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(e.getEnglishText()));
		 translationElement.appendChild(originalTextElement);

		 Element translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(" "));
		 translationElement.appendChild(translatedTextElement);
	     }
	}
    }
    private static void addEmailTranslations(Document doc, Element emailsElement, List<EmailTranslation> emails, List<EnglishEmail> englishEmails) {
	if(emails != null) {
	     for(EmailTranslation e: emails) {
		 Element emailElement = doc.createElement("email");
		 emailsElement.appendChild(emailElement);
		 
		 Element idElement = doc.createElement("type");
		 idElement.appendChild(doc.createTextNode(e.getId().getEmailType().toString()));
		 emailElement.appendChild(idElement);

		 // subject tag
		 Element subjectElement = doc.createElement("subject");
		 emailElement.appendChild(subjectElement);
		 
		 Element originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(e.getEnglishEmail().getSubject()));
		 subjectElement.appendChild(originalTextElement);

		 Element translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(e.getSubject()));
		 subjectElement.appendChild(translatedTextElement);
		 
		 
		 // body tag
		 Element bodyElement = doc.createElement("body");
		 emailElement.appendChild(bodyElement);
		 
		 originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(e.getEnglishEmail().getBody()));
		 bodyElement.appendChild(originalTextElement);

		 translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(e.getBody()));
		 bodyElement.appendChild(translatedTextElement);
	     }
	}
	if(englishEmails != null) {
	     for(EnglishEmail e: englishEmails) {
		 Element emailElement = doc.createElement("email");
		 emailsElement.appendChild(emailElement);
		 
		 Element idElement = doc.createElement("type");
		 idElement.appendChild(doc.createTextNode(e.getEmailType().toString()));
		 emailElement.appendChild(idElement);

		 // subject tag
		 Element subjectElement = doc.createElement("subject");
		 emailElement.appendChild(subjectElement);
		 
		 Element originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(e.getSubject()));
		 subjectElement.appendChild(originalTextElement);

		 Element translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(" "));
		 subjectElement.appendChild(translatedTextElement);
		 
		 
		 // body tag
		 Element bodyElement = doc.createElement("body");
		 emailElement.appendChild(bodyElement);
		 
		 originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(e.getBody()));
		 bodyElement.appendChild(originalTextElement);

		 translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(" "));
		 bodyElement.appendChild(translatedTextElement);

	     }
	}

    }

    private static String convertToString(Document doc) throws TransformerException {
	StringWriter writer = new StringWriter();
	StreamResult result = new StreamResult(writer);
	TransformerFactory tf = TransformerFactory.newInstance();
	Transformer transformer = tf.newTransformer();
	transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
	
	doc.setXmlStandalone(true);
	DOMSource domSource = new DOMSource(doc);
	transformer.transform(domSource, result);
	
	return writer.toString().replace("> </", "></");
	
    }
    
    
}
