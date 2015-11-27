/**
 * 
 */
package gr.ictpro.mall.service;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface GenericService <T, ID extends Serializable> {
	public void create(T item);
	public void update(T item);
	public void delete(ID id);
	public T retrieveById(ID id);
	public List<T> listAll();
	public List<T> listByProperty(String propertyName, Object propertyValue);
	public List<T> listByProperties(Map<String, Object> properties);
}
