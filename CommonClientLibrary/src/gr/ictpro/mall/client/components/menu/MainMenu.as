package gr.ictpro.mall.client.components.menu
{
	import mx.collections.ArrayList;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.view.CalendarMonthView;
	import gr.ictpro.mall.client.view.ClassroomgroupsView;
	import gr.ictpro.mall.client.view.ClassroomsView;
	import gr.ictpro.mall.client.view.LanguagesView;
	import gr.ictpro.mall.client.view.SettingsView;
	import gr.ictpro.mall.client.view.UserView;
	import gr.ictpro.mall.client.view.UsersView;

	public class MainMenu
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;
		
		
		public function MainMenu()
		{
		}
		
		public function getMenu(user:User):ArrayList
		{
			var res:ArrayList = new ArrayList();
			res.addItem(new MenuItemGroup(Device.tranlations.getTranslation("Manage")));

			// System Settings (admin) 
			if(UserModel.isAdmin(user)) {
				res.addItem(new MenuItemInternalModule(Device.tranlations.getTranslation("Server Settings"), Icons.icon_settings, SettingsView)); 
				res.addItem(new MenuItemInternalModule(Device.tranlations.getTranslation("Languages"), Icons.icon_languages, LanguagesView)); 
			}
			
			if(UserModel.isAdmin(user) || UserModel.isTeacher(user)) {
				res.addItem(new MenuItemInternalModule(Device.tranlations.getTranslation("Classrooms"), Icons.icon_classrooms, ClassroomsView)); 
				res.addItem(new MenuItemInternalModule(Device.tranlations.getTranslation("Classroom Groups"), Icons.icon_classroomgroup, ClassroomgroupsView)); 
				res.addItem(new MenuItemInternalModule(Device.tranlations.getTranslation("Users"), Icons.icon_users, UsersView)); 
			}
			
			res.addItem(new MenuItemGroup(""));

			//Calendar View (common to all roles)
			res.addItem(new MenuItemInternalModule(Device.tranlations.getTranslation("Calendar"), Icons.icon_calendar, CalendarMonthView)); 

			//Profile editor (common to all roles)
			res.addItem(new MenuItemInternalModule(Device.tranlations.getTranslation("Profile"), Icons.icon_profile, UserView)); 
			
			
			// Exit command (common to all roles)
			res.addItem(new MenuItemGroup(""));
			res.addItem(new MenuItemCommand(Device.tranlations.getTranslation("Exit"), Icons.icon_logout, runtimeSettings.terminate));
			
			return res;
		}
		
		
	}
}