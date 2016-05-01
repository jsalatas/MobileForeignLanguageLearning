package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Calendar;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Classroomgroup;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.utils.boolean.Answer;
	import gr.ictpro.mall.client.view.ClassroomView;
	import gr.ictpro.mall.client.view.components.ClassroomComponent;
	import gr.ictpro.mall.client.view.components.TranslationManagerComponent;

	public class ClassroomModel extends AbstractModel implements IServerPersistent
	{
		public function ClassroomModel()
		{
			super(Classroom, ClassroomView, ClassroomComponent);
			addDetail(new DetailMapper("Translations", null, null, TranslationManagerComponent, null, null, answerFalse, null, null, null));
			addDetail(new DetailMapper("Groups", "classroomgroups", Classroomgroup, null, null, null, answerFalse, null, null, null));
			addDetail(new DetailMapper("Students", "students", User, null, null, UserModel.isStudent, answerFalse, null, null, null));
			addDetail(new DetailMapper("Schedule and Calendar", "calendars", Calendar, null, null, null, answerTrue, null, null, null));

		}

		public function answerFalse(o:Object):Boolean
		{
			return false;
		}
		
		public function answerTrue(o:Object):Boolean
		{
			return true;
		}
		

		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Classroom.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Classroom.");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Get Classrooms.");
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