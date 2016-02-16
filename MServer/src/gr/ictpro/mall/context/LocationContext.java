package gr.ictpro.mall.context;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import flex.messaging.io.amf.ASObject;
import gr.ictpro.mall.model.Location;
import gr.ictpro.mall.model.User;
import gr.ictpro.mall.model.WifiTag;
import gr.ictpro.mall.service.GenericService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class LocationContext {

    @Autowired(required = true)
    private GenericService<Location, Integer> locationService;

    @Autowired(required = true)
    private GenericService<WifiTag, Integer> wifiTagService;


    public void storeLocation(User user, ArrayList<WifiTag> currentLocation) {
	Set<User> users = new HashSet<User>();
	users.add(user);
	Set<WifiTag> wifiTags = new HashSet<WifiTag>();
	for(WifiTag w: currentLocation) {
	    if(!w.getSsid().equals("")) {
		wifiTags.add(w);
	    }
	}
	
	
	Location location = new Location(users, wifiTags);
	locationService.create(location);
	
	for(WifiTag w:wifiTags) {
	    w.setLocation(location);
	    wifiTagService.create(w);
	}
	
    }

    
    public boolean isInKnownLocation(User user, ArrayList<WifiTag> currentLocation) {
	boolean res = false;
	
	for(Location location:user.getLocations()) {
	    if(getDistance(currentLocation, new ArrayList<WifiTag>(location.getWifiTags())) <0.5) {
		res = true;
		break;
	    }
	}
	
	return res;
    }

    public boolean isInProximity(ArrayList<WifiTag> location1, ArrayList<WifiTag> location2) {
	boolean res = false;
	
	if(getDistance(location1, location2) <0.5) {
		res = true;
	}
	
	return res;
    }

    private ArrayList<WifiTag> deepCopy(ArrayList<WifiTag> l) {
	ArrayList<WifiTag> res = new ArrayList<WifiTag>();
	
	for(WifiTag w: l) {
	    res.add(new WifiTag(null, w.getSsid(), w.getRssi()));
	}
	
	return res;
    }
    

    private void normalizePairs(ArrayList<WifiTag> l1, ArrayList<WifiTag> l2) {
	boolean found;
	for(WifiTag w1:l1) {
	    found = false;
	    for(WifiTag w2:l2) {
		if(w1.getSsid().equals(w2.getSsid())) {
		    found = true;
		    break;
		}
	    }
	    if(!found) {
		l2.add(new WifiTag(null, w1.getSsid(), -1000));
	    }
	}

	for(WifiTag w1:l2) {
	    found = false;
	    for(WifiTag w2:l1) {
		if(w1.getSsid().equals(w2.getSsid())) {
		    found = true;
		    break;
		}
	    }
	    if(!found) {
		l1.add(new WifiTag(null, w1.getSsid(), -1000));
	    }
	}
    }

    private double getDistance(ArrayList<WifiTag> a, ArrayList<WifiTag> b) {
	double distance = 0; 

	ArrayList<WifiTag> l1 = deepCopy(a);
	ArrayList<WifiTag> l2 = deepCopy(b);
	
	normalizePairs(l1, l2);
	
	for(WifiTag w1:l1) {
	    for(WifiTag w2:l2) {
		if(w1.getSsid().equals(w2.getSsid())) {
		    distance += Math.pow(w1.getSignalClassification() -w2.getSignalClassification(), 2);
		    break;
		}
	    }
	}

	return distance/l1.size();
    }


    public Set<WifiTag> parseLocationTags(ASObject locationObj) {
	Set<WifiTag> location = new HashSet<WifiTag>();
	Object[] ssids = (Object[]) locationObj.get("ssids");
	for(Object obj:ssids) {
	    ASObject tag = (ASObject) obj;
	    WifiTag w = new WifiTag(null, (String)tag.get("name"), ((int) tag.get("strength"))*1.);
	    location.add(w);
	}

	return location;
    }
}
