package gr.ictpro.mall.client.components.menu
{
	import mx.collections.ArrayList;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.MenuChangedSignal;
	import gr.ictpro.mall.client.view.CalendarMonthView;
	import gr.ictpro.mall.client.view.ClassroomgroupsView;
	import gr.ictpro.mall.client.view.ClassroomsView;
	import gr.ictpro.mall.client.view.LanguagesView;
	import gr.ictpro.mall.client.view.MeetingsView;
	import gr.ictpro.mall.client.view.SettingsView;
	import gr.ictpro.mall.client.view.UserView;
	import gr.ictpro.mall.client.view.UsersView;

	public class MainMenu
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;
		
		[Inject]
		public var menuChangedSignal:MenuChangedSignal;
		
		
		public function MainMenu()
		{
		}
		
		public function getMenu(user:User):ArrayList
		{
			var res:ArrayList = new ArrayList();

			// Communications (common to all users)
			res.addItem(new MenuItemGroup(Device.translations.getTranslation("Communications")));
			res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Meetings"), Icons.icon_meeting, MeetingsView));

			res.addItem(new MenuItemGroup(Device.translations.getTranslation("Manage")));
			// System Settings (admin) 
			if(UserModel.isAdmin(user)) {
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Server Settings"), Icons.icon_settings, SettingsView)); 
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Languages"), Icons.icon_languages, LanguagesView)); 
			}
			
			// System Settings (admin and teacher) 
			if(UserModel.isAdmin(user) || UserModel.isTeacher(user)) {
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Classrooms"), Icons.icon_classrooms, ClassroomsView)); 
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Classroom Groups"), Icons.icon_classroomgroup, ClassroomgroupsView)); 
			}
			if(UserModel.isAdmin(user) || UserModel.isTeacher(user) || UserModel.isParent(user)) {
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Users"), Icons.icon_users, UsersView));
			}
			
			//Calendar View (common to all roles)
			res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Calendar"), Icons.icon_calendar, CalendarMonthView)); 

			//Profile editor (common to all roles)
			res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Profile"), Icons.icon_profile, UserView)); 
			
			
			// Exit command (common to all roles)
			res.addItem(new MenuItemGroup(""));
			res.addItem(new MenuItemCommand(Device.translations.getTranslation("Exit"), Icons.icon_logout, runtimeSettings.terminate));
			
			menuChangedSignal.dispatch();

			return res;
		}
		
		
	}
}