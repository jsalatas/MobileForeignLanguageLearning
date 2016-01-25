package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Classroom")]
	public class Classroom 
	{
		public var id:Number;
		public var name:String;
		public var notes:String; 
		public var language:Language;
		public var translations:ArrayCollection;
		public var classroomgroups:ArrayCollection;
		public var emailTranslations:ArrayCollection;
		public var students:ArrayCollection;
		public var teacher:User;
		public var calendars:ArrayCollection;
		
		public function Classroom()
		{
		}

		public function toString():String
		{
			return name + (language!=null?" ("+language.code+")":"");
		}
	}
}