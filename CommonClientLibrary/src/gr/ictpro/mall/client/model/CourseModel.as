package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Course;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.CourseView;
	import gr.ictpro.mall.client.view.components.CourseComponent;

	public class CourseModel extends AbstractModel implements IServerPersistent
	{
		public function CourseModel()
		{
			super(Course, CourseView, CourseComponent);
		}
		
		public function get destination():String
		{
			return "courseRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateCourse";
		}
		
		public function get deleteMethod():String
		{
			return "deleteCourse";
		}
		
		public function get listMethod():String
		{
			return "getCourses";
		}
		
		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Course.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Course.");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Courses.");
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