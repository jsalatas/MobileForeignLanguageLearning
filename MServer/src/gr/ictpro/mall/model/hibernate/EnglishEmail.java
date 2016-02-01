package gr.ictpro.mall.model.hibernate;

// Generated Jan 31, 2016 7:54:21 PM by Hibernate Tools 4.0.0

import gr.ictpro.mall.model.EmailType;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * EnglishEmail generated by hbm2java
 */
@Entity
@Table(name = "english_email")
public class EnglishEmail implements java.io.Serializable {

    private EmailType emailType;
    private String body;
    private String subject;
    private Set<EmailTranslation> emailTranslations = new HashSet<EmailTranslation>(0);

    public EnglishEmail() {
    }

    public EnglishEmail(EmailType emailType, String body, String subject) {
	this.emailType = emailType;
	this.body = body;
	this.subject = subject;
    }

    public EnglishEmail(EmailType emailType, String body, String subject, Set<EmailTranslation> emailTranslations) {
	this.emailType = emailType;
	this.body = body;
	this.subject = subject;
	this.emailTranslations = emailTranslations;
    }

    @Id
    @Column(name = "email_type", unique = true, nullable = false)
    public EmailType getEmailType() {
	return this.emailType;
    }

    public void setEmailType(EmailType emailType) {
	this.emailType = emailType;
    }

    @Column(name = "body", nullable = false, length = 65535)
    public String getBody() {
	return this.body;
    }

    public void setBody(String body) {
	this.body = body;
    }

    @Column(name = "subject", nullable = false, length = 100)
    public String getSubject() {
	return this.subject;
    }

    public void setSubject(String subject) {
	this.subject = subject;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "englishEmail")
    public Set<EmailTranslation> getEmailTranslations() {
	return this.emailTranslations;
    }

    public void setEmailTranslations(Set<EmailTranslation> emailTranslations) {
	this.emailTranslations = emailTranslations;
    }

}
