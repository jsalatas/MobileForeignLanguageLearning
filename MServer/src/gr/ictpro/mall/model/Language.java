package gr.ictpro.mall.model;

// Generated Nov 30, 2015 9:51:50 PM by Hibernate Tools 4.0.0

import gr.ictpro.mall.interceptors.ClientReferenceClass;

import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.springframework.flex.core.io.AmfIgnore;

/**
 * Language generated by hbm2java
 */
@Entity
@Table(name = "language")
@ClientReferenceClass(className="gr.ictpro.mall.client.model.vo.Language")
public class Language implements java.io.Serializable {
    /**
     * 
     */
    private static final long serialVersionUID = -334921026852220970L;
    
    private String code;
    private String englishName;
    private String localName;
    private Set<Classroom> classrooms = new HashSet<Classroom>(0);
    private Set<Translation> translations = new HashSet<Translation>(0);
    private Set<EmailTranslation> emailTranslations = new HashSet<EmailTranslation>(0);

    public Language() {
    }

    public Language(String code, String englishName, String localName) {
	this.code = code;
	this.englishName = englishName;
	this.localName = localName;
    }

    public Language(String code, String englishName, String localName, Set<Classroom> classrooms,
	    Set<Translation> translations, Set<EmailTranslation> emailTranslations) {
	this.code = code;
	this.englishName = englishName;
	this.localName = localName;
	this.classrooms = classrooms;
	this.translations = translations;
	this.emailTranslations = emailTranslations;
    }

    @Id
    @Column(name = "code", unique = true, nullable = false, length = 5)
    public String getCode() {
	return this.code;
    }

    public void setCode(String code) {
	this.code = code;
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

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "language")
    public Set<Classroom> getClassrooms() {
	return this.classrooms;
    }

    public void setClassrooms(Set<Classroom> classrooms) {
	this.classrooms = classrooms;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "language")
    @AmfIgnore
    public Set<Translation> getTranslations() {
	return this.translations;
    }

    @AmfIgnore
    public void setTranslations(Set<Translation> translations) {
	this.translations = translations;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "language")
    @AmfIgnore
    public Set<EmailTranslation> getEmailTranslations() {
	return this.emailTranslations;
    }

    @AmfIgnore
    public void setEmailTranslations(Set<EmailTranslation> emailTranslations) {
	this.emailTranslations = emailTranslations;
    }

}
