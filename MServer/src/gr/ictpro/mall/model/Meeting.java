package gr.ictpro.mall.model;

// Generated Mar 10, 2016 8:58:08 PM by Hibernate Tools 4.0.0


import gr.ictpro.mall.interceptors.ClientReferenceClass;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.springframework.flex.core.io.AmfIgnore;

/**
 * Meeting generated by hbm2java
 */
@Entity
@Table(name = "meeting")
@ClientReferenceClass(className="gr.ictpro.mall.client.model.vo.Meeting")
public class Meeting implements java.io.Serializable {

    private Integer id;
    private User approvedBy;
    private User createdBy;
    private MeetingType meetingType;
    private String name;
    private String password;
    private Date time;
    private boolean approve;
    private Set<MeetingUser> meetingUsers = new HashSet<MeetingUser>(0);
    private Set<User> pendingUsers = new HashSet<User>(0);

    public Meeting() {
    }

    public Meeting(MeetingType meetingType, String name, String password, Date time, User createdBy) {
	this.meetingType = meetingType;
	this.name = name;
	this.password = password;
	this.time = time;
	this.createdBy = createdBy;
    }

    public Meeting(User approvedBy, MeetingType meetingType, String name, String password, Date time,
	    Set<MeetingUser> meetingUsers, User createdBy) {
	this.approvedBy = approvedBy;
	this.meetingType = meetingType;
	this.name = name;
	this.password = password;
	this.time = time;
	this.meetingUsers = meetingUsers;
	this.createdBy = createdBy;
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

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "approved_by")
    public User getApprovedBy() {
	return this.approvedBy;
    }

    public void setApprovedBy(User approvedBy) {
	this.approvedBy = approvedBy;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "meeting_type_id", nullable = false)
    public MeetingType getMeetingType() {
	return this.meetingType;
    }

    public void setMeetingType(MeetingType meetingType) {
	this.meetingType = meetingType;
    }

    @Column(name = "name", nullable = false, length = 45)
    public String getName() {
	return this.name;
    }

    public void setName(String name) {
	this.name = name;
    }

    @Column(name = "password", nullable = false, length = 45)
    public String getPassword() {
	return this.password;
    }

    public void setPassword(String password) {
	this.password = password;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "time", nullable = false, length = 19)
    public Date getTime() {
	return this.time;
    }

    public void setTime(Date time) {
	this.time = time;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "meeting")
    @AmfIgnore
    public Set<MeetingUser> getMeetingUsers() {
	return this.meetingUsers;
    }

    @AmfIgnore
    public void setMeetingUsers(Set<MeetingUser> meetingUsers) {
	this.meetingUsers = meetingUsers;
    }
    
    @Transient
    public Set<User> getUsers() {
	if(this.pendingUsers != null && this.pendingUsers.size()>0) {
	    return pendingUsers;
	}
	
	Set<User> res = new HashSet<User>();
	for(MeetingUser mu: meetingUsers) {
	    res.add(mu.getUser());
	}
	
	
	return res;
    }
    
    @Transient
    public void setUsers(Set<User> users) {
	pendingUsers = users;
    }

    @Transient
    public boolean isApprove() {
        return approve || approvedBy != null;
    }

    @Transient
    public void setApprove(boolean approve) {
        this.approve = approve;
    }
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "created_by", nullable = false)
    public User getCreatedBy() {
	return this.createdBy;
    }

    public void setCreatedBy(User createdBy) {
	this.createdBy = createdBy;
    }

}