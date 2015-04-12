package gr.ictpro.mall.model;

// Generated Sep 5, 2014 11:12:49 PM by Hibernate Tools 4.0.0

import java.util.Collection;
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
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

/**
 * User generated by hbm2java
 */
@Entity
@Table(name = "user", uniqueConstraints = {
	@UniqueConstraint(columnNames = "username"),
	@UniqueConstraint(columnNames = "email") })
public class User implements java.io.Serializable, UserDetails {

    private Integer id;
    private String username;
    private String password;
    private String email;
    private boolean enabled;
    private Set<Role> roles = new HashSet<Role>(0);
    private Profile profile;
    
    public User() {
    }

    public User(String username, String password, String email, boolean enabled) {
	this.username = username;
	this.password = password;
	this.email = email;
	this.enabled = enabled;
    }

    public User(String username, String password, String email, boolean enabled, Set<Role> roles, Profile profile) {
	this.username = username;
	this.password = password;
	this.email = email;
	this.enabled = enabled;
	this.roles = roles;
	this.profile = profile;
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

    @Column(name = "username", unique = true, nullable = false, length = 20)
    public String getUsername() {
	return this.username;
    }

    public void setUsername(String username) {
	this.username = username;
    }

    @Column(name = "password", nullable = false, length = 60)
    public String getPassword() {
	return this.password;
    }

    public void setPassword(String password) {
	this.password = password;
    }

    @Column(name = "email", unique = true, nullable = false, length = 45)
    public String getEmail() {
	return this.email;
    }

    public void setEmail(String email) {
	this.email = email;
    }

    @Column(name = "enabled", nullable = false)
    public boolean isEnabled() {
	return this.enabled;
    }

    public void setEnabled(boolean enabled) {
	this.enabled = enabled;
    }

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "user_role", joinColumns = { @JoinColumn(name = "user_id", nullable = false, updatable = false) }, inverseJoinColumns = { @JoinColumn(name = "role_id", nullable = false, updatable = false) })
    @OrderBy("id")
    public Set<Role> getRoles() {
	return this.roles;
    }

    @OneToOne(fetch = FetchType.EAGER, mappedBy = "user")
    public Profile getProfile() {
	return this.profile;
    }

    public void setProfile(Profile profile) {
	this.profile = profile;
    }

    public void setRoles(Set<Role> roles) {
	this.roles = roles;
    }

    @Override
    public int hashCode() {
	final int prime = 31;
	int result = 1;
	result = prime * result + ((id == null) ? 0 : id.hashCode());
	return result;
    }

    @Override
    public boolean equals(Object obj) {
	if (this == obj)
	    return true;
	if (obj == null)
	    return false;
	if (getClass() != obj.getClass())
	    return false;
	User other = (User) obj;
	if (id == null) {
	    if (other.id != null)
		return false;
	} else if (!id.equals(other.id))
	    return false;
	return true;
    }

    @Override
    public String toString() {
	return username + " <" + email + ">";
    }

    @Override
    @Transient
    public Collection<? extends GrantedAuthority> getAuthorities() {
	return this.roles;
    }

    @Override
    @Transient
    public boolean isAccountNonExpired() {
	return true;
    }

    @Override
    @Transient
    public boolean isAccountNonLocked() {
	return this.enabled;
    }

    @Override
    @Transient
    public boolean isCredentialsNonExpired() {
	return true;
    }

}
