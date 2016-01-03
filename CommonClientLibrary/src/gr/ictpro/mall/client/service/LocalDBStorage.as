package gr.ictpro.mall.client.service
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	import gr.ictpro.mall.client.model.IClientPersistent;
	
	public class LocalDBStorage
	{
		private static const DB_FILE:String = "settings.db";
		private var _connection:SQLConnection = new SQLConnection();
		
		[PostConstruct]
		public function initializeStorage():void {
			if(!_connection.connected) {
				var initDB:Boolean = false;
				var file:File = File.applicationStorageDirectory.resolvePath(DB_FILE);
				_connection.open(file);
			}
		}
		
		public function get connection():SQLConnection
		{
			return this._connection;
		}
		
		public function saveObject(model:IClientPersistent, vo:Object):void
		{
			model.saveObject(vo);
		}

		public function loadObjects(model:IClientPersistent):void
		{
			model.loadObjects();
		}

		public function deleteObject(model:IClientPersistent, vo:Object):void
		{
			model.deleteObject(vo);
		}
	}
}