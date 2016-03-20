package gr.ictpro.mall.client.model.vo
{
	import gr.ictpro.mall.client.runtime.Device;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Role")]
	public class Role
	{
		public var id:Number;
		public var role:String;
		
		public function Role()
		{
		}
		
		public function toString():String
		{
			return Device.translations.getTranslation(role);
		}

	}
}