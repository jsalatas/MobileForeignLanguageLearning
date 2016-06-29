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
	import gr.ictpro.mall.client.view.CourseTemplatesView;
	import gr.ictpro.mall.client.view.CoursesView;
	import gr.ictpro.mall.client.view.LanguagesView;
	import gr.ictpro.mall.client.view.MeetingsView;
	import gr.ictpro.mall.client.view.ProjectsView;
	import gr.ictpro.mall.client.view.SettingsView;
	import gr.ictpro.mall.client.view.UserView;
	import gr.ictpro.mall.client.view.UsersView;

	public class MainMenu
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;
		
		[Inject]
		public var menuChangedSignal:MenuChangedSignal;
		
		
		private var _addonMenu:ArrayList = new ArrayList();
		
		public function MainMenu()
		{
		}
		
		public function registerMenuItem(menuItem:MenuItem):void {
			_addonMenu.addItem(menuItem);
			runtimeSettings.menu = this.getMenu(runtimeSettings.user);
		}
		
		public function getMenu(user:User):ArrayList
		{
			var res:ArrayList = new ArrayList();

			if(UserModel.isAdmin(user)) {
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Server Settings"), Icons.icon_settings, SettingsView)); 
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Languages"), Icons.icon_languages, LanguagesView)); 
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Course Templates"), Icons.icon_template, CourseTemplatesView)); 
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Courses"), Icons.icon_course, CoursesView));
			}

			if(UserModel.isAdmin(user) || UserModel.isTeacher(user)) {
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Projects"), Icons.icon_project, ProjectsView));
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Classrooms"), Icons.icon_classrooms, ClassroomsView)); 
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Classroom Groups"), Icons.icon_classroomgroup, ClassroomgroupsView)); 
			}

			res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Meetings"), Icons.icon_meeting, MeetingsView));
			
			if(UserModel.isStudent(user) || UserModel.isTeacher(user)) {
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Courses"), Icons.icon_course, CoursesView));
			}

			if(UserModel.isAdmin(user) || UserModel.isTeacher(user) || UserModel.isParent(user)) {
				res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Users"), Icons.icon_users, UsersView));
			}
			
			res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Calendar"), Icons.icon_calendar, CalendarMonthView)); 

			res.addItem(new MenuItemInternalModule(Device.translations.getTranslation("Profile"), Icons.icon_profile, UserView)); 
			
			// add on menus
			if(_addonMenu.length > 0) {
				res.addItem(new MenuItemGroup(""));
				res.addAll(_addonMenu);
			}
			
			res.addItem(new MenuItemGroup(""));
			res.addItem(new MenuItemCommand(Device.translations.getTranslation("Exit"), Icons.icon_logout, runtimeSettings.terminate));
			
			menuChangedSignal.dispatch();

			return res;
		}
		
		
	}
}