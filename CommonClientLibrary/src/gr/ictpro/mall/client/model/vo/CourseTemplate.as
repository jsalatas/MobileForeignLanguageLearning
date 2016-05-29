package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.CourseTemplate")]
	public class CourseTemplate
	{
		public var id:Number;
		public var name:String;
		public var moodleId:String;
		public var courses:ArrayCollection;

		public function CourseTemplate()
		{
		}
		
		public function toString():String
		{
			return name;
		}

	}
}