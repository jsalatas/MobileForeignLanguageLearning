package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Project")]
	public class Project
	{
		public var id:Number;
		public var name:String;
		public var notes:String;
		public var courses:ArrayCollection;
		public var users:ArrayCollection;

		public function Project()
		{
		}
		
		public function toString():String
		{
			return name;
		}
	}
}