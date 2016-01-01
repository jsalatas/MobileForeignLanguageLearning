package gr.ictpro.mall.client.runtime
{
	import mx.collections.ArrayList;
	
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.model.vo.User;

	public class RuntimeSettings
	{
		public static const SERVER_URL:String = "server.url";
		public static const APP_PATH:String = "server.applicationPath";
		public static const MODULES_PATH:String = "server.modulesPath";
		
		private var _clientSettings:Object = null;
		private var _user:User = null;
		private var _menu:ArrayList = null;
		
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
		
		[Bindable]
		public function get menu():ArrayList 
		{
			return _menu; 
		}
		
		public function set menu(menu:ArrayList):void 
		{
			this._menu = menu;
		}
	}
}