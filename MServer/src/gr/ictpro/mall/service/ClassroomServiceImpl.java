/**
 * 
 */
package gr.ictpro.mall.service;

import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import gr.ictpro.mall.model.Classroom;
import gr.ictpro.mall.model.User;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
@Service
public class ClassroomServiceImpl extends GenericServiceImpl<Classroom, Integer> implements ClassroomService {
    /*
     * (non-Javadoc)
     * @see gr.ictpro.mall.service.GenericServiceImpl#listAll()
     */
    @Transactional
    @Override
    public List<Classroom> listAll() {
        // Never show the master classroom 
	return listByCustomSQL("FROM Classroom WHERE id <> 0");
    }

    @Transactional
    @Override
    public void replaceTeacher(Classroom c, User newTeacher) {
	if (c.getUsers() instanceof HibernateProxy) {
	    Hibernate.initialize(c.getUsers());
	}

	//remove old teacher
	for (User u : c.getUsers()) {
	    if (u.hasRole("Teacher")) {
		c.getUsers().remove(u);
		break;
	    }
	}
	c.getUsers().add(newTeacher);
	update(c);
    }

}
