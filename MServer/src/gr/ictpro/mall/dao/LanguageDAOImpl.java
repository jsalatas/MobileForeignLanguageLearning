/**
 * 
 */
package gr.ictpro.mall.dao;

import gr.ictpro.mall.model.Language;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class LanguageDAOImpl implements LanguageDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }


    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(Language item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(Language item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#delete(java.lang.Object)
     */
    @Override
    public void delete(String id) {
	Session session = this.sessionFactory.getCurrentSession();
	Language l = (Language) session.load(Language.class, id);
	if (null != l) {
	    session.delete(l);
	}
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#retrieveById(java.lang.Object)
     */
    @Override
    public Language retrieveById(String id) {
	Session session = this.sessionFactory.getCurrentSession();
	Language l = (Language) session.load(Language.class, id);
	return l;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Language> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<Language> languageList = session.createQuery("from Language order by englishName").list();
	return languageList;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.dao.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Language> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(Language.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<Language> languageList = criteria.list();
	return languageList;
    }

}
