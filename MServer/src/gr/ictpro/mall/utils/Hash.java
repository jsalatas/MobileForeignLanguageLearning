/**
 * 
 */
package gr.ictpro.mall.utils;

import java.util.GregorianCalendar;
import java.util.Random;

import org.apache.commons.codec.digest.DigestUtils;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class Hash {

    private static Random rng = new Random(GregorianCalendar.getInstance().getTimeInMillis());
    
    
    public static String getSHA256(String input) {
	String str = input + GregorianCalendar.getInstance().getTimeInMillis() + rng.nextLong();
	String sha256 = DigestUtils.sha256Hex(str);
	return sha256;
    }
}
