/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.model.ConfigDAOImpl;
import gr.ictpro.mall.model.Email;
import gr.ictpro.mall.model.EmailDAO;
import gr.ictpro.mall.model.EmailDAOImpl;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class EmailServiceImpl implements EmailService, EmailDAO {
    private EmailDAOImpl emailDAO;

    public void setEmailDAO(EmailDAOImpl emailDAO) {
	this.emailDAO = emailDAO;
    }


    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(Email item) {
	emailDAO.create(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(Email item) {
	emailDAO.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#delete(int)
     */
    @Transactional
    @Override
    public void delete(int id) {
	emailDAO.delete(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#retrieveById(int)
     */
    @Transactional
    @Override
    public Email retrieveById(int id) {
	return emailDAO.retrieveById(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<Email> listAll() {
	return emailDAO.listAll();
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listByProperty(java.lang.String, java.lang.Object)
     */
    @Transactional
    @Override
    public List<Email> listByProperty(String propertyName, Object propertyValue) {
	return emailDAO.listByProperty(propertyName, propertyValue);
    }

}
