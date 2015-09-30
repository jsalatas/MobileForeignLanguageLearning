/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.dao.LanguageDAO;
import gr.ictpro.mall.model.Language;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class LanguageServiceImpl implements LanguageService {
    private LanguageDAO languageDAO;

    public void setLanguageDAO(LanguageDAO languageDAO) {
	this.languageDAO = languageDAO;
    }


    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#create(java.lang.Object)
     */
    @Transactional
    @Override
    public void create(Language item) {
	languageDAO.create(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#update(java.lang.Object)
     */
    @Transactional
    @Override
    public void update(Language item) {
	languageDAO.update(item);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#delete(java.lang.Object)
     */
    @Transactional
    @Override
    public void delete(String id) {
	languageDAO.delete(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#retrieveById(java.lang.Object)
     */
    @Transactional
    @Override
    public Language retrieveById(String id) {
	return languageDAO.retrieveById(id);
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listAll()
     */
    @Transactional
    @Override
    public List<Language> listAll() {
	return languageDAO.listAll();
    }

    /* (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericService#listByProperty(java.lang.String, java.lang.Object)
     */
    @Transactional
    @Override
    public List<Language> listByProperty(String propertyName, Object propertyValue) {
	return languageDAO.listByProperty(propertyName, propertyValue);
    }

}
