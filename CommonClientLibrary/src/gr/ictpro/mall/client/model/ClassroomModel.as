package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Calendar;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Classroomgroup;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.ClassroomView;
	import gr.ictpro.mall.client.view.components.ClassroomComponent;
	import gr.ictpro.mall.client.view.components.TranslationManagerComponent;

	public class ClassroomModel extends AbstractModel implements IServerPersistent
	{
		public function ClassroomModel()
		{
			super(Classroom, ClassroomView, ClassroomComponent);
			addDetail(new DetailMapper("Translations", null, null, TranslationManagerComponent, null, null, false, null, null));
			addDetail(new DetailMapper("Groups", "classroomgroups", Classroomgroup, null, null, null, false, null, null));
			addDetail(new DetailMapper("Students", "students", User, null, filterStudents, null, false, null, null));
			addDetail(new DetailMapper("Schedule and Calendar", "calendars", Calendar, null, null, null, true, null, null));

		}

		private function filterStudents(item:Object):Boolean
		{
			var userModel:UserModel = UserModel(mapper.getModelforVO(User));
			var user:User = User(item);
			return UserModel.isStudent(user);
		}
		
		public function get saveErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Save Classroom");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Delete Classroom");
		}
		
		public function get listErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Get Classrooms");
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}
		
		public function get destination():String
		{
			return "classroomRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateClassroom";
		}
		
		public function get deleteMethod():String
		{
			return "deleteClassroom";
		}
		
		public function get listMethod():String
		{
			return "getClassrooms";
		}
	}
}