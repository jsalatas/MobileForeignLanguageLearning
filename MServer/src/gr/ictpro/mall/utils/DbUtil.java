/**
 * 
 */

package gr.ictpro.mall.utils;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

/**
 * @author John Salatas <jsalatas@gmail.com>
 * 
 */

public class DbUtil {
    private String initSQL;
    private DataSource dataSource;

    public void setInitSQL(String initSQL) {
	this.initSQL = initSQL;
    }

    public void setDataSource(DataSource dataSource) {
	this.dataSource = dataSource;
    }

    public void initialize() throws FileNotFoundException, IOException, URISyntaxException {
	String[] scriptFiles = initSQL.split(",");
	try {
	    Connection connection = dataSource.getConnection();
	    ScriptRunner runner = new ScriptRunner(connection, false, true);
	    runner.setLogWriter(null);
	    runner.setErrorLogWriter(null);
	    
	    for (String scriptFile : scriptFiles) {
		URL url;
		if (scriptFile.startsWith("classpath:")) {
		    url = this.getClass().getResource(scriptFile.replace("classpath:", ""));
		} else {
		    url = new URL(scriptFile);
		}
		URI uri = new URI(url.toString());
		runner.runScript(new BufferedReader(new FileReader(uri.getPath())));		
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
    }
}
