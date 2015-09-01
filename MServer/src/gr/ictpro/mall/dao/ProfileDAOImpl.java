/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.Profile;
import gr.ictpro.mall.model.Role;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class ProfileDAOImpl implements ProfileDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(Profile item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(Profile item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#delete(int)
     */
    @Override
    public void delete(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Profile p = (Profile) session.load(Profile.class, id);
	if (null != p) {
	    session.delete(p);
	}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#retrieveById(int)
     */
    @Override
    public Profile retrieveById(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Profile p = (Profile) session.load(Profile.class, id);
	return p;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Profile> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<Profile> profilesList = session.createQuery("from Profile order by user_id").list();
	return profilesList;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Profile> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(Role.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<Profile> profilesList = criteria.list();
	return profilesList;
    }

}
