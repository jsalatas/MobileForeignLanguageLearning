package gr.ictpro.mall.model;

// Generated Jul 26, 2015 11:10:47 AM by Hibernate Tools 4.0.0

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Email generated by hbm2java
 */
@Entity
@Table(name = "email")
public class Email implements java.io.Serializable {

    private int id;
    private String subject;
    private String body;

    public Email() {
    }

    public Email(int id, String subject, String body) {
	this.id = id;
	this.subject = subject;
	this.body = body;
    }

    @Id
    @Column(name = "id", unique = true, nullable = false)
    public int getId() {
	return this.id;
    }

    public void setId(int id) {
	this.id = id;
    }

    @Column(name = "subject", nullable = false, length = 100)
    public String getSubject() {
	return this.subject;
    }

    public void setSubject(String subject) {
	this.subject = subject;
    }

    @Column(name = "body", nullable = false, length = 65535, columnDefinition="Text")
    public String getBody() {
	return this.body;
    }

    public void setBody(String body) {
	this.body = body;
    }

}
