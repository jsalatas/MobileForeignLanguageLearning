/**
 * 
 */

package gr.ictpro.mall.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

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

    public void initialize() throws FileNotFoundException, IOException {
	String[] scriptFiles = initSQL.split(",");
	try {
	    Connection connection = dataSource.getConnection();
	    Statement statement = connection.createStatement();
	    for (String scriptFile : scriptFiles) {
		ArrayList<String> commands = getSQLCommands(scriptFile);
		for (String command : commands) {
		    statement.execute(command);
		}
	    }
	    ;
	    statement.close();
	    connection.close();
	} catch (SQLException e) {
	    e.printStackTrace();
	}
    }

    private ArrayList<String> getSQLCommands(String scriptFile) throws FileNotFoundException, IOException {
	InputStream in = null;
	ArrayList<String> res = new ArrayList<String>();
	try {
	    if (scriptFile.startsWith("classpath:")) {
		in = this.getClass().getResourceAsStream(scriptFile.replace("classpath:", ""));
	    } else {
		in = new FileInputStream(new File(scriptFile));
	    }
	    BufferedReader reader = new BufferedReader(new InputStreamReader(in, "UTF-8"));
	    String line;
	    while ((line = reader.readLine()) != null) {
		if (line.trim().length() > 0) {
		    res.add(line);
		}
	    }
	} finally {
	    if (in != null) {
		try {
		    in.close();
		} catch (IOException e) {
		}
	    }
	}

	return res;
    }
}
