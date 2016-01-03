package gr.ictpro.mall.client.runtime
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import gr.ictpro.mall.client.model.vo.User;

	public class RuntimeSettings
	{
		public static const SERVER_URL:String = "server.url";
		public static const APP_PATH:String = "server.applicationPath";
		public static const MODULES_PATH:String = "server.modulesPath";
		
		private var _user:User = null;
		private var _menu:ArrayList = null;
		
		public var language:String;
		
		public function RuntimeSettings()
		{
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
		
		public function terminate():void
		{
			var exitingEvent:Event = new Event(Event.EXITING, false, true); 
			NativeApplication.nativeApplication.dispatchEvent(exitingEvent); 
			if (!exitingEvent.isDefaultPrevented()) { 
				NativeApplication.nativeApplication.exit(); 
			} 
			
		}

	}
}