package gr.ictpro.mall.client.model.menu
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.User;
	
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
			if(user.roles.getItemIndex("Admin") != -1) {
				res.addItem(new MenuItemGroup("Manage"));
				res.addItem(new MenuItemModule("Settings", Icons.icon_settings, user.color, "Settings")); 
				res.addItem(new MenuItemModule("Profile", Icons.icon_profile, user.color, "Profile")); 
				res.addItem(new MenuItemGroup(""));
				res.addItem(new MenuItemCommand("Exit", Icons.icon_logout, user.color, logout));
			}
			
			if(user.roles.getItemIndex("Teacher") != -1) {
				
			}
			
			if(user.roles.getItemIndex("Student") != -1) {
				
			}
			
			if(user.roles.getItemIndex("Parent") != -1) {
				
			}
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