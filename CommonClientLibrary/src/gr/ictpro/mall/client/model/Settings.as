package gr.ictpro.mall.client.model
{
	public class Settings
	{
		public static const SERVER_URL:String = "server.name";
		public static const APP_PATH:String = "server.applicationPath";
		public static const MODULES_PATH:String = "server.modulesPath";
		
		private var _settings:Object = null;
		private var _user:User = null;
		
		private var _serverConfiguration:ServerConfiguration = null;
		
		public function Settings()
		{
		}
		
		public function get settings():Object 
		{
			return _settings; 
		}
		
		public function set settings(settings:Object):void 
		{
			this._settings = settings;
		}

		public function get serverConfiguration():ServerConfiguration 
		{
			return _serverConfiguration; 
		}
		
		public function set serverConfiguration(serverConfiguration:ServerConfiguration):void 
		{
			this._serverConfiguration = serverConfiguration;
		}

		
		public function getSetting(name:String):String
		{
			if(_settings != null && _settings.hasOwnProperty(name))
			{
				return _settings[name];
			}
			return null;
		}

		[Bindable]
		public function get user():User 
		{
			return _user; 
		}
		
		public function set user(user:User):void 
		{
			this._user = user;
		}
		

	
	
	
	}
}