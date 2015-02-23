/**
 * 
 */
package gr.ictpro.mall.helper;

import gr.ictpro.mall.model.Config;

import java.util.List;

/**
 * @author John Salatas <jsalatas@gmail.com>
 *
 */
public class ServerConfiguration {
    
    private List<Config> configs;

    public ServerConfiguration() {
	
    }
    
    public ServerConfiguration(List<Config> configs) {
	this.configs = configs;
    }

    public List<Config> getConfigs() {
        return configs;
    }
    
    public void setConfigs(List<Config> configs) {
        this.configs = configs;
    }
    
}
