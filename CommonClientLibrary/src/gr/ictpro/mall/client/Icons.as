package gr.ictpro.mall.client
{
	import assets.fxg.calendar;
	import assets.fxg.camera;
	import assets.fxg.classroom;
	import assets.fxg.folder;
	import assets.fxg.languages;
	import assets.fxg.link;
	import assets.fxg.logout;
	import assets.fxg.profile;
	import assets.fxg.settings;

	public final class Icons
	{
		public static const icon_defaultProfile:profile = new profile();
		public static const icon_settings:settings = new settings();    
		public static const icon_languages:languages = new languages();    
		public static const icon_classrooms:classroom = new classroom();    
		public static const icon_classroomgroup:link = new link();    
		public static const icon_profile:profile = new profile();
		public static const icon_logout:logout = new logout();
		public static const icon_camera:camera = new camera();
		public static const icon_folder:folder = new folder();
		public static const icon_calendar:calendar = new calendar();
		
		public function Icons()
		{
		}
	}
}