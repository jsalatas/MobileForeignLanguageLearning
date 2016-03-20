package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;
	
	import gr.ictpro.mall.client.runtime.Device;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.User")]
	public class User
	{
		public var id:Number;
		public var username:String;
		public var password:String;
		public var email:String;
		public var enabled:Boolean;
		public var profile:Profile;
		public var roles:ArrayCollection;
		public var calendars:ArrayCollection;
		public var teacherClassrooms:ArrayCollection;
		public var classrooms:ArrayCollection;
		public var disallowUnattendedMeetings:Boolean;
		public var autoApproveUnattendedMeetings:Boolean;
		public var available:Boolean;
		public var parents:ArrayCollection;
		public var children:ArrayCollection;
		[Transient]
		public var currentClassroom:Classroom;


		public function User()
		{
		}
		
		public function toString():String
		{
			var allRoles:String = "";
			for each(var role:Role in roles) {
				if(allRoles != "") {
					allRoles = allRoles + ", ";
				}
				allRoles = allRoles + Device.translations.getTranslation(role.role);
			}
			
			return profile +" ("+allRoles+")";
		}

	}
}