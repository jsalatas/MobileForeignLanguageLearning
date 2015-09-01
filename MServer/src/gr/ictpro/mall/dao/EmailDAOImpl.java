/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.Email;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class EmailDAOImpl implements EmailDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }


    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(Email item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(Email item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#delete(int)
     */
    @Override
    public void delete(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Email e = (Email) session.load(Email.class, id);
	if (null != e) {
	    session.delete(e);
	}
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#retrieveById(int)
     */
    @Override
    public Email retrieveById(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Email e = (Email) session.load(Email.class, id);
	return e;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Email> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<Email> emailsList = session.createQuery("from Email order by id").list();
	return emailsList;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Email> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(Email.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<Email> emailsList = criteria.list();
	return emailsList;
    }

}
