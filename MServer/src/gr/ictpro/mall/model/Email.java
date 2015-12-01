package gr.ictpro.mall.model;

// Generated Nov 30, 2015 9:51:50 PM by Hibernate Tools 4.0.0


import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * Email generated by hbm2java
 */
@Entity
@Table(name = "email"
	, uniqueConstraints = @UniqueConstraint(columnNames = { "language_code", "email_type" }))
public class Email implements java.io.Serializable {

    private int id;
    private Language language;
    private EmailType emailType;
    private String body;
    private String subject;

    public Email() {
    }

    public Email(int id, Language language, EmailType emailType, String body, String subject) {
	this.id = id;
	this.language = language;
	this.emailType = emailType;
	this.body = body;
	this.subject = subject;
    }

    @Id
    @Column(name = "id", unique = true, nullable = false)
    public int getId() {
	return this.id;
    }

    public void setId(int id) {
	this.id = id;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "language_code", nullable = false)
    public Language getLanguage() {
	return this.language;
    }

    public void setLanguage(Language language) {
	this.language = language;
    }

    @Column(name = "email_type", nullable = false, length = 45)
    public EmailType getEmailType() {
	return this.emailType;
    }

    public void setEmailType(EmailType emailType) {
	this.emailType = emailType;
    }

    @Column(name = "body", nullable = false, length = 65535, columnDefinition = "Text")
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

}
