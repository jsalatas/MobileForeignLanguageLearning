/**
 * 
 */
package gr.ictpro.mall.utils;

import java.io.UnsupportedEncodingException;

import com.google.gson.Gson;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class Serialize {
    public static byte[] serialize(Object obj) {
	Gson json = new Gson();
	try {
	    return json.toJson(obj).getBytes("UTF8");
	} catch (UnsupportedEncodingException e) {
	    return null;
	}	
    }
    
    public static String deserialize(byte[] bytes) {
	try {
	    return new String(bytes, "UTF8");
	} catch (UnsupportedEncodingException e) {
	    return null;
	}
    }
}
