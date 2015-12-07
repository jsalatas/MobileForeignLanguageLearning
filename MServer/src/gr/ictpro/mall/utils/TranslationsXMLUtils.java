package gr.ictpro.mall.utils;


import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.EmailTranslation;
import gr.ictpro.mall.model.EnglishEmail;
import gr.ictpro.mall.model.EnglishText;
import gr.ictpro.mall.model.Language;
import gr.ictpro.mall.model.Translation;

import java.io.StringWriter;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

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
		 
		 Element idElement = doc.createElement("id");
		 idElement.appendChild(doc.createTextNode(Integer.toString(e.getId())));
		 emailElement.appendChild(idElement);

		 // subject tag
		 Element subjectElement = doc.createElement("subject");
		 emailElement.appendChild(subjectElement);
		 
		 Element originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(e.getEnglishEmail().getSubject()));
		 subjectElement.appendChild(originalTextElement);

		 Element translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(e.getSubject()));
		 subjectElement.appendChild(originalTextElement);
		 
		 
		 // body tag
		 Element bodyElement = doc.createElement("body");
		 emailElement.appendChild(subjectElement);
		 
		 originalTextElement = doc.createElement("originalText");
		 originalTextElement.appendChild(doc.createTextNode(e.getEnglishEmail().getBody()));
		 subjectElement.appendChild(originalTextElement);

		 translatedTextElement = doc.createElement("translatedText");
		 translatedTextElement.appendChild(doc.createTextNode(e.getBody()));
		 subjectElement.appendChild(originalTextElement);
	     }
	}
	if(englishEmails != null) {
	     for(EnglishEmail e: englishEmails) {
		 Element emailElement = doc.createElement("email");
		 emailsElement.appendChild(emailElement);
		 
		 Element idElement = doc.createElement("id");
		 idElement.appendChild(doc.createTextNode(Integer.toString(e.getId())));
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
	
	DOMSource domSource = new DOMSource(doc);
	transformer.transform(domSource, result);
	
	return writer.toString().replace("> </", "></");
	
    }
}
