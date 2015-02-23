/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.List;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface GenericService <T> {
	public void create(T item);
	public void update(T item);
	public void delete(int id);
	public T retrieveById(int id);
	public List<T> listAll();
	public List<T> listByProperty(String propertyName, Object propertyValue);
}
