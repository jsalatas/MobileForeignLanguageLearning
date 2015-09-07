/**
 * 
 */
package gr.ictpro.mall.dao;

import java.util.List;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface GenericDAO<T, S> {
	public void create(T item);
	public void update(T item);
	public void delete(S id);
	public T retrieveById(S id);
	public List<T> listAll();
	public List<T> listByProperty(String propertyName, Object propertyValue);
}