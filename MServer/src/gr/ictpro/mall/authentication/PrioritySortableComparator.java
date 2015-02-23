/**
 * 
 */
package gr.ictpro.mall.authentication;

import java.util.Comparator;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class PrioritySortableComparator implements Comparator<PrioritySortable> {

    /* (non-Javadoc)
     * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
     */
    @Override
    public int compare(PrioritySortable arg0, PrioritySortable arg1) {
	if(arg0.getPriority()>arg1.getPriority()) {
	    return -1;
	} else if (arg0.getPriority()<arg1.getPriority()) {
	    return 1;
	}
	return 0;
    }

}
