/**
 * 
 */
package gr.ictpro.mall.interceptors;

import gr.ictpro.mall.flex.MessagingService;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */
@Aspect
public class CRUDClientNotifier {
    
    
    @AfterReturning("execution(* gr.ictpro.mall.dao.GenericDAO.*(Object)) && @annotation(PersistentObjectModifier)")
    public void afterCRUDoperation(JoinPoint jp) {
	Object[] parameterList = jp.getArgs();
	MessagingService.objectsChanged(parameterList[0]);
    }
}
