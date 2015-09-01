/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.Config;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class ConfigDAOImpl implements ConfigDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }


    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(Config item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(Config item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#delete(int)
     */
    @Override
    public void delete(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Config c = (Config) session.load(Config.class, id);
	if (null != c) {
	    session.delete(c);
	}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#retrieveById(int)
     */
    @Override
    public Config retrieveById(Integer id) {
	Session session = this.sessionFactory.getCurrentSession();
	Config c = (Config) session.load(Config.class, id);
	return c;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Config> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<Config> configsList = session.createQuery("from Config order by id").list();
	return configsList;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Config> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(Config.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<Config> configsList = criteria.list();
	return configsList;
    }

}
