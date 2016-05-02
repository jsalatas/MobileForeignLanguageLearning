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
		public var status:String;
		public var time:Date;
		public var record:Boolean;
		public var parentCanSeeRecording:Boolean;
		public var currentUserIsApproved:Boolean;
		public var users:ArrayCollection;
		[Transient]
		public var url:String;
		
		public function Meeting()
		{
		}
	}
}