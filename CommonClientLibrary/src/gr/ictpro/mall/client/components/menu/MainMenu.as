package gr.ictpro.mall.client.components.menu
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.view.ClassroomgroupsView;
	import gr.ictpro.mall.client.view.ClassroomsView;
	import gr.ictpro.mall.client.view.LanguagesView;
	import gr.ictpro.mall.client.view.SettingsView;
	import gr.ictpro.mall.client.view.UserView;

	public class MainMenu
	{
		[Inject]
		public var userModel:UserModel;
	
		[Inject]
		public var runtimeSettings:RuntimeSettings;
		
		
		public function MainMenu()
		{
		}
		
		public function getMenu(user:User):ArrayList
		{
			var res:ArrayList = new ArrayList();
			res.addItem(new MenuItemGroup(Translation.getTranslation("Manage")));

			// System Settings (admin) 
			if(userModel.isAdmin(user)) {
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Server Settings"), Icons.icon_settings, Device.defaultColorTransform, SettingsView)); 
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Languages"), Icons.icon_languages, Device.defaultColorTransform, LanguagesView)); 
			}
			
			if(userModel.isAdmin(user) || userModel.isTeacher(user)) {
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Classrooms"), Icons.icon_classrooms, Device.defaultColorTransform, ClassroomsView)); 
				res.addItem(new MenuItemInternalModule(Translation.getTranslation("Classroom Groups"), Icons.icon_classroomgroup, Device.defaultColorTransform, ClassroomgroupsView)); 
			}
			
			//Profile editor (common to all roles)
			res.addItem(new MenuItemInternalModule(Translation.getTranslation("Profile"), Icons.icon_profile, Device.defaultColorTransform, UserView)); 
			
			// Exit command (common to all roles)
			res.addItem(new MenuItemGroup(""));
			res.addItem(new MenuItemCommand(Translation.getTranslation("Exit"), Icons.icon_logout, Device.defaultColorTransform, runtimeSettings.terminate));
			
			return res;
		}
		
		
	}
}