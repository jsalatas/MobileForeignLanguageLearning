package gr.ictpro.mall.model;

// Generated Nov 30, 2015 9:51:50 PM by Hibernate Tools 4.0.0

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * TranslationId generated by hbm2java
 */
@Embeddable
public class TranslationId implements java.io.Serializable {

    private int englishTextId;
    private String languageCode;

    public TranslationId() {
    }

    public TranslationId(int englishTextId, String languageCode) {
	this.englishTextId = englishTextId;
	this.languageCode = languageCode;
    }

    @Column(name = "english_text_id", nullable = false)
    public int getEnglishTextId() {
	return this.englishTextId;
    }

    public void setEnglishTextId(int englishTextId) {
	this.englishTextId = englishTextId;
    }

    @Column(name = "language_code", nullable = false, length = 5)
    public String getLanguageCode() {
	return this.languageCode;
    }

    public void setLanguageCode(String languageCode) {
	this.languageCode = languageCode;
    }

    public boolean equals(Object other) {
	if ((this == other))
	    return true;
	if ((other == null))
	    return false;
	if (!(other instanceof TranslationId))
	    return false;
	TranslationId castOther = (TranslationId) other;

	return (this.getEnglishTextId() == castOther.getEnglishTextId())
		&& ((this.getLanguageCode() == castOther.getLanguageCode()) || (this.getLanguageCode() != null
			&& castOther.getLanguageCode() != null && this.getLanguageCode().equals(
			castOther.getLanguageCode())));
    }

    public int hashCode() {
	int result = 17;

	result = 37 * result + this.getEnglishTextId();
	result = 37 * result + (getLanguageCode() == null ? 0 : this.getLanguageCode().hashCode());
	return result;
    }

}
