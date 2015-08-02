/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.model.Notification;
import gr.ictpro.mall.model.NotificationDAOImpl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class NotificationServiceImpl implements NotificationService {
    private NotificationDAOImpl notificationDAO;

    public void setNotificationDAO(NotificationDAOImpl notificationDAO) {
	this.notificationDAO = notificationDAO;
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(Notification item) {
	notificationDAO.create(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(Notification item) {
	notificationDAO.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#delete(int)
     */
    @Transactional
    @Override
    public void delete(int id) {
	notificationDAO.delete(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#retrieveById(int)
     */
    @Transactional
    @Override
    public Notification retrieveById(int id) {
	return notificationDAO.retrieveById(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<Notification> listAll() {
	return notificationDAO.listAll();
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listByProperty(java.lang.String, java.lang.Object)
     */
    @Transactional
    @Override
    public List<Notification> listByProperty(String propertyName, Object propertyValue) {
	return notificationDAO.listByProperty(propertyName, propertyValue);
    }
}
