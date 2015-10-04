/**
 * 
 */
package gr.ictpro.mall.dao;

import java.io.Serializable;
import java.util.List;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface GenericDAO<T, ID extends Serializable> {
	public void create(T item);
	public void update(T item);
	public void delete(ID id);
	public T retrieveById(ID id);
	public List<T> listAll();
	public List<T> listByProperty(String propertyName, Object propertyValue);
}
