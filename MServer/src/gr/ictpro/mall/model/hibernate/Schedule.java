package gr.ictpro.mall.model.hibernate;

// Generated Jan 31, 2016 7:54:21 PM by Hibernate Tools 4.0.0

import java.util.Date;
import java.util.HashSet;
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

/**
 * Schedule generated by hbm2java
 */
@Entity
@Table(name = "schedule")
public class Schedule implements java.io.Serializable {

    private Integer id;
    private User user;
    private Classroom classroom;
    private int day;
    private String description;
    private Date endTime;
    private int repeatEvery;
    private int repeatInterval;
    private Date repeatUntil;
    private Date startTime;
    private Set<Calendar> calendars = new HashSet<Calendar>(0);

    public Schedule() {
    }

    public Schedule(int day, String description, Date endTime, int repeatEvery, int repeatInterval, Date repeatUntil,
	    Date startTime) {
	this.day = day;
	this.description = description;
	this.endTime = endTime;
	this.repeatEvery = repeatEvery;
	this.repeatInterval = repeatInterval;
	this.repeatUntil = repeatUntil;
	this.startTime = startTime;
    }

    public Schedule(User user, Classroom classroom, int day, String description, Date endTime, int repeatEvery,
	    int repeatInterval, Date repeatUntil, Date startTime, Set<Calendar> calendars) {
	this.user = user;
	this.classroom = classroom;
	this.day = day;
	this.description = description;
	this.endTime = endTime;
	this.repeatEvery = repeatEvery;
	this.repeatInterval = repeatInterval;
	this.repeatUntil = repeatUntil;
	this.startTime = startTime;
	this.calendars = calendars;
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    public User getUser() {
	return this.user;
    }

    public void setUser(User user) {
	this.user = user;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "classroom_id")
    public Classroom getClassroom() {
	return this.classroom;
    }

    public void setClassroom(Classroom classroom) {
	this.classroom = classroom;
    }

    @Column(name = "day", nullable = false)
    public int getDay() {
	return this.day;
    }

    public void setDay(int day) {
	this.day = day;
    }

    @Column(name = "description", nullable = false)
    public String getDescription() {
	return this.description;
    }

    public void setDescription(String description) {
	this.description = description;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_time", nullable = false, length = 19)
    public Date getEndTime() {
	return this.endTime;
    }

    public void setEndTime(Date endTime) {
	this.endTime = endTime;
    }

    @Column(name = "repeat_every", nullable = false)
    public int getRepeatEvery() {
	return this.repeatEvery;
    }

    public void setRepeatEvery(int repeatEvery) {
	this.repeatEvery = repeatEvery;
    }

    @Column(name = "repeat_interval", nullable = false)
    public int getRepeatInterval() {
	return this.repeatInterval;
    }

    public void setRepeatInterval(int repeatInterval) {
	this.repeatInterval = repeatInterval;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "repeat_until", nullable = false, length = 19)
    public Date getRepeatUntil() {
	return this.repeatUntil;
    }

    public void setRepeatUntil(Date repeatUntil) {
	this.repeatUntil = repeatUntil;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_time", nullable = false, length = 19)
    public Date getStartTime() {
	return this.startTime;
    }

    public void setStartTime(Date startTime) {
	this.startTime = startTime;
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "schedule")
    public Set<Calendar> getCalendars() {
	return this.calendars;
    }

    public void setCalendars(Set<Calendar> calendars) {
	this.calendars = calendars;
    }

}
