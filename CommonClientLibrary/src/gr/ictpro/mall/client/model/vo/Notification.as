package gr.ictpro.mall.client.model.vo
{
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Notification")]
	public class Notification
	{
		public var id:Number;
		public var date:Date;
		public var message:String;
		public var module:String;
		public var parameters:ByteArray;
		public var subject:String;
		public var internalModule:Boolean;
		public var actionNeeded:Boolean;
		
		public function Notification()
		{
		}
		
		public function toString():String
		{
			return subject;
		}

	}
}