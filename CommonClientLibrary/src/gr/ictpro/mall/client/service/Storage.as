package gr.ictpro.mall.client.service
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	public class Storage
	{
		private static var _dbFile:String = "settings.db";
		private static var _connection:SQLConnection = new SQLConnection();
		
		public static function loadSettings():Object
		{
			if(!_connection.connected) {
				var initDB:Boolean = false;
				var file:File = File.applicationStorageDirectory.resolvePath(_dbFile);
				if(!file.exists) {
					initDB = true;
				}
				_connection.open(file);
				if(initDB) {
					createDatabase();
				}
				
			}
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _connection;
			statement.text = "SELECT * FROM settings";
			statement.execute();
			var result:SQLResult = statement.getResult();
			var settingsObj:Object = new Object();
			if(result != null && result.data != null) 
			{
				var rows:int = result.data.length;
				for(var i:int = 0; i<rows; i++) 
				{
					var row:Object = result.data[i];
					settingsObj[row.name] = row.value;
				}
			}
			
			return settingsObj;
		}
		
		
		private static function createDatabase(): void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _connection;
			statement.text = "CREATE TABLE IF NOT EXISTS settings ("
				+ "name TEXT PRIMARY KEY NOT NULL, "
				+ "value TEXT NOT NULL"
				+");";
			try {
				statement.execute();
			} catch (error:Error) {
				trace(error);
			}
		}
		
		public static function saveSetting(name:String, value:String):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _connection;
			statement.text = "INSERT OR REPLACE INTO settings (name, value) VALUES('"+name+"', '"+value+"')";
			try {
				statement.execute();
			} catch (error:Error) {
				trace(error);
			}
						
		}
	}
}