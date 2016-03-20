package gr.ictpro.mall.client.model.vo
{
	import gr.ictpro.mall.client.runtime.Device;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.MeetingType")]
	public class MeetingType
	{
		public var id:Number;
		public var name:String;
		public var clientClass:String;
		public var internalModule:Boolean;

		public function MeetingType()
		{
		}
		
		public function toString():String
		{
			return Device.translations.getTranslation(name);
		}
	}
}