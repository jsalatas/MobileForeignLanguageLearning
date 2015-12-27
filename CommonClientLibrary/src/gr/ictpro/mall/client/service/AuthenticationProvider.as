package gr.ictpro.mall.client.service
{
	import flash.events.EventDispatcher;

	public class AuthenticationProvider extends EventDispatcher
	{
		private var _provider:String;
		private var _className:String;
		
		public function AuthenticationProvider(provider:String, className:String)
		{
			this._provider = provider;
			this._className = className;
		}
		
		public function get provider():String
		{
			return _provider;
		}

		public function get className():String
		{
			return _className;
		}

	}
}