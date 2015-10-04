package gr.ictpro.mall.client.model.menu
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.Device;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.model.User;

	public class MainMenu
	{
		public function MainMenu()
		{
			throw new Error("Main Menu should be used a static class");
		}
		
		public static function getMenu(user:User):ArrayList
		{
			var res:ArrayList = new ArrayList();
			res.addItem(new MenuItemGroup(Translation.getTranslation("Manage")));

			// System Settings (admin) 
			if(user.roles.getItemIndex("Admin") != -1) {
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Settings"), Icons.icon_settings, Device.defaultColorTransform, "gr.ictpro.mall.client.view.SettingsView")); 
			}
			
			//Profile editor (common to all roles)
			res.addItem(new MenuItemInternalModule(Translation.getTranslation("Profile"), Icons.icon_profile, Device.defaultColorTransform, "gr.ictpro.mall.client.view.ProfileView")); 
			
			// Exit command (common to all roles)
			res.addItem(new MenuItemGroup(""));
			res.addItem(new MenuItemCommand(Translation.getTranslation("Exit"), Icons.icon_logout, Device.defaultColorTransform, logout));
			
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