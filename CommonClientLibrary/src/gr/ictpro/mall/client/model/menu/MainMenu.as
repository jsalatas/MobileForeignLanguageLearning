package gr.ictpro.mall.client.model.menu
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.view.ProfileView;
	import gr.ictpro.mall.client.view.SettingsView;
	
	import mx.collections.ArrayList;

	public class MainMenu
	{
		public function MainMenu()
		{
			throw new Error("Main Menu should be used a static class");
		}
		
		public static function getMenu(user:User):ArrayList
		{
			var res:ArrayList = new ArrayList();
			res.addItem(new MenuItemGroup("Manage"));

			// System Settings (admin) 
			if(user.roles.getItemIndex("Admin") != -1) {
				res.addItem(new MenuItemInternalModule("Settings", Icons.icon_settings, user.color, "gr.ictpro.mall.client.view.SettingsView")); 
			}
			
			//Profile editor (common to all roles)
			res.addItem(new MenuItemInternalModule("Profile", Icons.icon_profile, user.color, "gr.ictpro.mall.client.view.ProfileView")); 
			
			// Exit command (common to all roles)
			res.addItem(new MenuItemGroup(""));
			res.addItem(new MenuItemCommand("Exit", Icons.icon_logout, user.color, logout));
			
			return res;
		}
		
		
		public static function logout():void
		{
			var exitingEvent:Event = new Event(Event.EXITING, false, true); 
			NativeApplication.nativeApplication.dispatchEvent(exitingEvent); 
			if (!exitingEvent.isDefaultPrevented()) { 
				NativeApplication.nativeApplication.exit(); 
			} 

		}
	}
}