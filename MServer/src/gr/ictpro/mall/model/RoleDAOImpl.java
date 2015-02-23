/**
 * 
 */
package gr.ictpro.mall.model;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
public class RoleDAOImpl implements RoleDAO {
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
	this.sessionFactory = sf;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#create(java.lang.Object)
     */
    @Override
    public void create(Role item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.persist(item);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#update(java.lang.Object)
     */
    @Override
    public void update(Role item) {
	Session session = this.sessionFactory.getCurrentSession();
	session.update(item);
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#delete(int)
     */
    @Override
    public void delete(int id) {
	Session session = this.sessionFactory.getCurrentSession();
	Role r = (Role) session.get(Role.class, new Integer(id));
	if (null != r) {
	    session.delete(r);
	}
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#retrieveById(int)
     */
    @Override
    public Role retrieveById(int id) {
	Session session = this.sessionFactory.getCurrentSession();
	Role r = (Role) session.get(Role.class, new Integer(id));
	return r;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listAll()
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Role> listAll() {
	Session session = this.sessionFactory.getCurrentSession();
	List<Role> rolesList = session.createQuery("from Role order by id").list();
	return rolesList;
    }

    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.model.GenericDAO#listByProperty(java.lang.String, java.lang.Object)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Role> listByProperty(String propertyName, Object propertyValue) {
	Session session = this.sessionFactory.getCurrentSession();
	Criteria criteria = session.createCriteria(Role.class);
	criteria.add(Restrictions.eq(propertyName, propertyValue));
	List<Role> rolesList = criteria.list();
	return rolesList;
    }

}
