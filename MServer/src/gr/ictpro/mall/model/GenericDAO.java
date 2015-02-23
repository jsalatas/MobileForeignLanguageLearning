/**
 * 
 */
package gr.ictpro.mall.model;

import java.util.List;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface GenericDAO<T> {
	public void create(T item);
	public void update(T item);
	public void delete(int id);
	public T retrieveById(int id);
	public List<T> listAll();
	public List<T> listByProperty(String propertyName, Object propertyValue);
}
