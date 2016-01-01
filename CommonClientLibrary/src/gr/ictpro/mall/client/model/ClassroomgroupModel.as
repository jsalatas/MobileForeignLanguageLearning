package gr.ictpro.mall.client.model
{
	
	import gr.ictpro.mall.client.model.vo.Classroomgroup;
	import gr.ictpro.mall.client.runtime.Translation;

	public class ClassroomgroupModel extends AbstractModel  implements IServerPersistent
	{
		public function ClassroomgroupModel()
		{
			super(Classroomgroup);
		}
		
		public function get deleteErrorMessage():String
		{
			return Translation.getTranslation("Cannot Delete Classroom Group");
		}
		
		public function get listErrorMessage():String
		{
			return Translation.getTranslation("Cannot Get Classroom Groups");
		}
		
		public function get saveErrorMessage():String
		{
			return Translation.getTranslation("Cannot Save Classroom Group");
		}
		
		public function get destination():String
		{
			return "classroomRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateClassroomgroup";
		}
		public function get deleteMethod():String
		{
			return "deleteClassroomgroup";
		}
		
		public function get listMethod():String
		{
			return "getClassroomgroups";
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