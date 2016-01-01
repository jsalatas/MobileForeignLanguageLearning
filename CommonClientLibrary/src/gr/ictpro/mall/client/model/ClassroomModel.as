package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.runtime.Translation;

	public class ClassroomModel extends AbstractModel implements IServerPersistent
	{
		public function ClassroomModel()
		{
			super(Classroom);
		}

		public function get saveErrorMessage():String
		{
			return Translation.getTranslation("Cannot Save Classroom");
		}
		
		public function get deleteErrorMessage():String
		{
			return Translation.getTranslation("Cannot Delete Classroom");
		}
		
		public function get listErrorMessage():String
		{
			return Translation.getTranslation("Cannot Get Classrooms");
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