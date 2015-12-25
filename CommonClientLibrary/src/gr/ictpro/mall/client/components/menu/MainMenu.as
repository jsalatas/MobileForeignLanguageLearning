package gr.ictpro.mall.client.components.menu
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.runtime.Device;
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
			if(user.isAdmin) {
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Server Settings"), Icons.icon_settings, Device.defaultColorTransform, "gr.ictpro.mall.client.view.SettingsView")); 
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Languages"), Icons.icon_languages, Device.defaultColorTransform, "gr.ictpro.mall.client.view.LanguagesView")); 
			}
			
			if(user.isAdmin || user.isTeacher) {
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Classrooms"), Icons.icon_classrooms, Device.defaultColorTransform, "gr.ictpro.mall.client.view.ClassroomsView")); 
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Classroom Groups"), Icons.icon_classroomgroup, Device.defaultColorTransform, "gr.ictpro.mall.client.view.ClassroomgroupsView")); 
			}
			
			//Profile editor (common to all roles)
			res.addItem(new MenuItemInternalModule(Translation.getTranslation("Profile"), Icons.icon_profile, Device.defaultColorTransform, "gr.ictpro.mall.client.view.UserView")); 
			
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