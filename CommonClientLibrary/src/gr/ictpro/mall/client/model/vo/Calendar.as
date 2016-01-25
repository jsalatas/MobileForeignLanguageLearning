package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;
	
	import gr.ictpro.mall.client.utils.date.DateUtils;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Calendar")]
	public class Calendar
	{
		public var id:Number;
		public var description:String;
		public var startTime:Date;
		public var endTime:Date;
		public var user:User;
		public var classroom:Classroom;
		public var schedule:Schedule;
		public var masterEntry:Calendar;
		public var childEntries:ArrayCollection;

		public function Calendar()
		{
		}
		
		public function toString():String
		{
			return DateUtils.toShortDateTime(startTime) + " - " + DateUtils.toShortDateTime(endTime) + ": " + description; 
		}
	}
}