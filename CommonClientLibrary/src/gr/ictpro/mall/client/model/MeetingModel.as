package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Meeting;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.view.MeetingView;
	import gr.ictpro.mall.client.view.components.MeetingComponent;

	public class MeetingModel extends AbstractModel implements IServerPersistent
	{
		[Inject] 
		public var runtimeSettings:RuntimeSettings;
		
		public var addFilter:Function;

		public function MeetingModel()
		{
			super(Meeting, MeetingView, MeetingComponent);
			addDetail(new DetailMapper("Users", "users", User, null, null, addFilterFunction, isReadOnly, beforeDeleteFunction, null, null));
		}
		
		public function addFilterFunction(item:User):Boolean {
			if(addFilter != null) {
				return addFilter(item);
			}
			return true;
		}

		public function beforeDeleteFunction(user:User, meeting:Meeting):Boolean {
			return meeting.createdBy== null || user.id != meeting.createdBy.id;
		}
		
		public function isReadOnly(meeting:Meeting):Boolean {
			if(meeting == null || meeting.createdBy == null) {
				return false; 
			}
			
			if(meeting.status == "completed") {
				return true;
			}
			
			if(UserModel.isStudent(runtimeSettings.user) && runtimeSettings.user.id != meeting.createdBy.id) {
				return true;
			}
			if (UserModel.isTeacher(runtimeSettings.user) || UserModel.isAdmin(runtimeSettings.user)) {
				return false;
			}
			return false;		
		}
		
		public function get destination():String
		{
			return "meetingRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateMeeting";
		}
		
		public function get deleteMethod():String
		{
			return "deleteMeeting";
		}
		
		public function get listMethod():String
		{
			return "getMeetings";
		}
		
		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Meeting.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Meeting.");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Get Meetings.");
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}
	}
}