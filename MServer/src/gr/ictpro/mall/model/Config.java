package gr.ictpro.mall.model;

// Generated Sep 14, 2014 9:03:44 PM by Hibernate Tools 4.0.0

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * Config generated by hbm2java
 */
@Entity
@Table(name = "config"
	, uniqueConstraints = @UniqueConstraint(columnNames = "name"))
public class Config implements java.io.Serializable {
    /**
     * 
     */
    private static final long serialVersionUID = -6937080813950945767L;
    
    private Integer id;
    private String name;
    private String value;

    public Config() {
    }

    public Config(String name, String value) {
	this.name = name;
	this.value = value;
    }

    @Id
    @GeneratedValue(strategy = IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    public Integer getId() {
	return this.id;
    }

    public void setId(Integer id) {
	this.id = id;
    }

    @Column(name = "name", unique = true, nullable = false, length = 50)
    public String getName() {
	return this.name;
    }

    public void setName(String name) {
	this.name = name;
    }

    @Column(name = "value", nullable = false, length = 100)
    public String getValue() {
	return this.value;
    }

    public void setValue(String value) {
	this.value = value;
    }

}
