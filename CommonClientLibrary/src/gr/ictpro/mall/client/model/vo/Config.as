package gr.ictpro.mall.client.model.vo
{

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Config")]
	public class Config
	{
		public var id:Number;
		public var name:String;
		public var value:String;
		
		public function Config()
		{
		}
		
		public function toString():String
		{
			return name;
		}
	}
}