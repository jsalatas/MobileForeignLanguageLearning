package gr.ictpro.mall.client.model.vo
{
	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Course")]
	public class Course
	{
		public var id:Number;
		public var name:String;
		public var courseTemplate:CourseTemplate;
		public var classroom:Classroom;
		public var classroomgroup:Classroomgroup;
		public var project:Project;

		public function Course()
		{
		}
		
		public function toString():String
		{
			return name;
		}
	}
}