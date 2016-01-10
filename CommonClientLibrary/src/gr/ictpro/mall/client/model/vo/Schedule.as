package gr.ictpro.mall.client.model.vo
{
	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Schedule")]
	public class Schedule
	{
		public var id:Number;
		public var classroom:Classroom;
		public var startTime:Date; 
		public var endTime:Date;
		public var repeatInterval:int;
		public var day:int;
		public var repeatUntil:Date;
		
		public function Schedule()
		{
		}
	}
}