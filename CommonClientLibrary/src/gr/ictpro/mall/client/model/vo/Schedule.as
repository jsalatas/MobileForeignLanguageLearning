package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Schedule")]
	public class Schedule
	{
		public var id:Number;
		public var description:String;
		public var startTime:Date; 
		public var endTime:Date;
		public var user:User;
		public var classroom:Classroom;
		public var day:int;
		public var repeatInterval:int;
		public var repeatUntil:Date;
		public var repeatEvery:int;
		public var calendarEntries:ArrayCollection;
		
		public function Schedule()
		{
		}
	}
}