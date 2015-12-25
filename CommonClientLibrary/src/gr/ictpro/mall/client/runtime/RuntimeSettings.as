package gr.ictpro.mall.client.runtime
{
	import gr.ictpro.mall.client.model.ServerConfiguration;
	import gr.ictpro.mall.client.model.User;

	public class RuntimeSettings
	{
		public static const SERVER_URL:String = "server.url";
		public static const APP_PATH:String = "server.applicationPath";
		public static const MODULES_PATH:String = "server.modulesPath";
		
		private var _clientSettings:Object = null;
		private var _user:User = null;
		
		private var _serverConfiguration:ServerConfiguration = null;
		
		public function RuntimeSettings()
		{
		}
		
		public function get clientSettings():Object 
		{
			return _clientSettings; 
		}
		
		public function set clientSettings(clientSettings:Object):void 
		{
			this._clientSettings = clientSettings;
		}

		public function get serverConfiguration():ServerConfiguration 
		{
			return _serverConfiguration; 
		}
		
		public function set serverConfiguration(serverConfiguration:ServerConfiguration):void 
		{
			this._serverConfiguration = serverConfiguration;
		}

		
		public function getClientSetting(name:String):String
		{
			if(_clientSettings != null && _clientSettings.hasOwnProperty(name))
			{
				return _clientSettings[name];
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