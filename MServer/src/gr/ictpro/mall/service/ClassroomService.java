/**
 * 
 */
package gr.ictpro.mall.service;

import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.User;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public interface ClassroomService extends GenericService<Classroom, Integer> {
    public void replaceTeacher(Classroom c, User newTeacher);

}
