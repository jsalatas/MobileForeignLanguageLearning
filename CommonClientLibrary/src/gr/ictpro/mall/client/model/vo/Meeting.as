package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Meeting")]
	public class Meeting
	{
		public var id:Number;
		public var approvedBy:User;
		public var createdBy:User;
		public var approve:Boolean;
		public var meetingType:MeetingType;
		public var name:String;
		public var moderatorPassword:String;
		public var usePassword:String;
		public var time:Date;
		public var users:ArrayCollection;
		
		public function Meeting()
		{
		}
	}
}