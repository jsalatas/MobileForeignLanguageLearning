package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Classroomgroup")]
	public class Classroomgroup
	{
		public var id:Number;
		public var name:String;
		public var notes:String;
		public var classrooms:ArrayCollection;

		public function Classroomgroup()
		{
		}
		
		public function toString():String
		{
			return name;
		}
}
}