package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Course;
	import gr.ictpro.mall.client.model.vo.CourseTemplate;
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.CourseTemplateView;
	import gr.ictpro.mall.client.view.components.CourseTemplateComponent;

	public class CourseTemplateModel extends AbstractModel implements IServerPersistent
	{
		public function CourseTemplateModel()
		{
			super(CourseTemplate, CourseTemplateView, CourseTemplateComponent);
			addDetail(new DetailMapper("Courses", "courses", Course, null, null, null, answerTrue, null, null, null));
		}
		
		public function answerFalse(o:Object):Boolean
		{
			return false;
		}

		public function answerTrue(o:Object):Boolean
		{
			return true;		
		}

		public function get destination():String
		{
			return "courseRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateCourseTemplate";
		}
		
		public function get deleteMethod():String
		{
			return "deleteCourseTemplate";
		}
		
		public function get listMethod():String
		{
			return "getCourseTemplates";
		}
		
		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Course Template.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Course Template.");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Course Templates.");
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