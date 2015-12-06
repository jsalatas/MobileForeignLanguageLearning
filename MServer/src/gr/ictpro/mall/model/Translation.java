package gr.ictpro.mall.model;

// Generated Nov 30, 2015 9:51:50 PM by Hibernate Tools 4.0.0

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * Translation generated by hbm2java
 */
@Entity
@Table(name = "translation")
public class Translation implements java.io.Serializable {

    private TranslationId id;
    private EnglishText englishText;
    private Language language;
    private Classroom classroom;
    private String translatedText;

    public Translation() {
    }

    public Translation(TranslationId id, EnglishText englishText, Language language, String translatedText) {
	this.id = id;
	this.englishText = englishText;
	this.language = language;
	this.translatedText = translatedText;
    }

    public Translation(TranslationId id, EnglishText englishText, Language language, Classroom classroom,
	    String translatedText) {
	this.id = id;
	this.englishText = englishText;
	this.language = language;
	this.classroom = classroom;
	this.translatedText = translatedText;
    }

    @EmbeddedId
    @AttributeOverrides({
	    @AttributeOverride(name = "englishTextId", column = @Column(name = "english_text_id", nullable = false)),
	    @AttributeOverride(name = "languageCode", column = @Column(name = "language_code", nullable = false, length = 5)) })
    public TranslationId getId() {
	return this.id;
    }

    public void setId(TranslationId id) {
	this.id = id;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "english_text_id", nullable = false, insertable = false, updatable = false)
    public EnglishText getEnglishText() {
	return this.englishText;
    }

    public void setEnglishText(EnglishText englishText) {
	this.englishText = englishText;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "language_code", nullable = false, insertable = false, updatable = false)
    public Language getLanguage() {
	return this.language;
    }

    public void setLanguage(Language language) {
	this.language = language;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "class_id")
    public Classroom getClassroom() {
	return this.classroom;
    }

    public void setClassroom(Classroom classroom) {
	this.classroom = classroom;
    }

    @Column(name = "translated_text", nullable = false, length = 65535, columnDefinition = "Text")
    public String getTranslatedText() {
	return this.translatedText;
    }

    public void setTranslatedText(String translatedText) {
	this.translatedText = translatedText;
    }

}
