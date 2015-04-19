/**
 * 
 */
package gr.ictpro.mall.model;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class UserDAOImpl implements UserDAO, UserDetailsService {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }

    @Override
    public void create(User item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    @Override
    public void update(User item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.merge(item);
    }

    @Override
    public void delete(int id) {
	Session session = this.sessionFactory.getCurrentSession();
	User u = (User) session.get(User.class, new Integer(id));
	if (null != u) {
	    session.delete(u);
	}
    }

    @Override
    public User retrieveById(int id) {
	Session session = this.sessionFactory.getCurrentSession();
	User u = (User) session.get(User.class, new Integer(id));
	return u;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<User> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<User> usersList = session.createQuery("from User").list();
	return usersList;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<User> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(User.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<User> usersList = criteria.list();
	return usersList;
    }

    @Override
    public UserDetails loadUserByUsername(String username)
	    throws UsernameNotFoundException {
	try {
	    return listByProperty("username", username).get(0);
	} catch (Exception e) {
	    throw new UsernameNotFoundException("Unknown user.");
	}
    }
}
