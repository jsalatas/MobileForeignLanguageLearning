package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Language")]
	public class Language
	{
		public var code:String;
		public var englishName:String;
		public var localName:String;
		public var classrooms:ArrayCollection;
		
		public function Language()
		{
		}
		
		public function toString():String
		{
			return localName;
		}

	}
}