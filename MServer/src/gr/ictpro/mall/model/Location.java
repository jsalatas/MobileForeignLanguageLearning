package gr.ictpro.mall.model;

// Generated Jan 31, 2016 7:54:21 PM by Hibernate Tools 4.0.0

import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * Location generated by hbm2java
 */
@Entity
@Table(name = "location")
public class Location implements java.io.Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = -5864544700675920739L;
    
    private Integer id;
    private Set<User> users = new HashSet<User>(0);
    private Set<WifiTag> wifiTags = new HashSet<WifiTag>(0);

    public Location() {
    }

    public Location(Set<User> users, Set<WifiTag> wifiTags) {
	this.users = users;
	this.wifiTags = wifiTags;
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

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "location_user", joinColumns = {
	    @JoinColumn(name = "location_id", nullable = false, updatable = false) }, inverseJoinColumns = {
	    @JoinColumn(name = "user_id", nullable = false, updatable = false) })
    public Set<User> getUsers() {
	return this.users;
    }

    public void setUsers(Set<User> users) {
	this.users = users;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "location")
    public Set<WifiTag> getWifiTags() {
	return this.wifiTags;
    }

    public void setWifiTags(Set<WifiTag> wifiTags) {
	this.wifiTags = wifiTags;
    }

}
