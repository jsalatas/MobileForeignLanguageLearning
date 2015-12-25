package gr.ictpro.mall.client.service
{
	import flash.events.EventDispatcher;

	public class AuthenticationProvider extends EventDispatcher
	{
		private var _provider:String;
		public function AuthenticationProvider(provider:String)
		{
			this._provider = provider;
		}
		
		public function get provider():String
		{
			return _provider;
		}
	}
}