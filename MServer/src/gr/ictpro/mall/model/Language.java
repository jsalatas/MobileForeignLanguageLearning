package gr.ictpro.mall.model;

// Generated Oct 3, 2015 2:40:56 PM by Hibernate Tools 4.0.0

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Language generated by hbm2java
 */
@Entity
@Table(name = "language")
public class Language implements java.io.Serializable {

    private String code;
    private boolean enabled;
    private String englishName;
    private String localName;

    public Language() {
    }

    public Language(String code, boolean enabled, String englishName, String localName) {
	this.code = code;
	this.enabled = enabled;
	this.englishName = englishName;
	this.localName = localName;
    }

    @Id
    @Column(name = "code", unique = true, nullable = false, length = 5)
    public String getCode() {
	return this.code;
    }

    public void setCode(String code) {
	this.code = code;
    }

    @Column(name = "enabled", nullable = false)
    public boolean isEnabled() {
	return this.enabled;
    }

    public void setEnabled(boolean enabled) {
	this.enabled = enabled;
    }

    @Column(name = "english_name", nullable = false, length = 100)
    public String getEnglishName() {
	return this.englishName;
    }

    public void setEnglishName(String englishName) {
	this.englishName = englishName;
    }

    @Column(name = "local_name", nullable = false, length = 100)
    public String getLocalName() {
	return this.localName;
    }

    public void setLocalName(String localName) {
	this.localName = localName;
    }

}