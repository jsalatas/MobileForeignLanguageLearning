package gr.ictpro.mall.client.model
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.IllegalOperationError;
	
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.service.LocalDBStorage;

	public class ClientSettingsModel extends AbstractModel implements IClientPersistent
	{
		
		private var _dbStorage:LocalDBStorage;

		public function ClientSettingsModel()
		{
			super(ClientSetting, null, null);
		}
		
		public function get saveErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Save Client Settings");
		}
		
		public function get deleteErrorMessage():String
		{
			throw new IllegalOperationError("Delete Operation not Permitted");
		}
		
		public function get listErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Get Client Settings");;
		}
		
		public function get idField():String
		{
			return "name";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return vo[idField] == null;;
		}
		
		public function saveObject(vo:Object):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _dbStorage.connection;
			statement.text = "INSERT OR REPLACE INTO settings (name, value) VALUES('"+vo.name+"', '"+vo.value+"')";
			statement.execute();
		}
		
		public function loadObjects():void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _dbStorage.connection;
			statement.text = "SELECT * FROM settings";
			statement.execute();
			var result:SQLResult = statement.getResult();
			list.removeAll();
			if(result != null && result.data != null) 
			{
				var rows:int = result.data.length;
				for(var i:int = 0; i<rows; i++) 
				{
					var row:Object = result.data[i];
					var clientSetting:ClientSetting = new ClientSetting();
					clientSetting.name = row.name;
					clientSetting.value = row.value;
					list.addItem(clientSetting);
				}
			}
		}

		public function deleteObject(vo:Object):void
		{
			throw new IllegalOperationError("Cannot Delete Client Settings"); 
		}
		
		public function initializeDB():void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _dbStorage.connection;
			statement.text = "CREATE TABLE IF NOT EXISTS settings ("
				+ "name TEXT PRIMARY KEY NOT NULL, "
				+ "value TEXT NOT NULL"
				+");";
			statement.execute();
		}
		
		[Inject]
		public function set dbStorage(dbStorage:LocalDBStorage):void
		{
			this._dbStorage = dbStorage;
			
		}
		

	}
}