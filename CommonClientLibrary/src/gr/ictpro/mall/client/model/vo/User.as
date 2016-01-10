package gr.ictpro.mall.client.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.User")]
	public class User
	{
		public var id:Number;
		public var username:String;
		public var password:String;
		public var email:String;
		public var enabled:Boolean;
		public var profile:Profile;
		public var roles:ArrayCollection;

		public function User()
		{
		}
		
		public function toString():String
		{
			return profile +" ("+username+")";
		}

	}
}