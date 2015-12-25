package gr.ictpro.mall.client.service
{
	import flash.events.EventDispatcher;

	public class RegistrationProvider extends EventDispatcher
	{
		private var _provider:String;
		public function RegistrationProvider(provider:String)
		{
			this._provider = provider;
		}
		
		public function get provider():String
		{
			return _provider;
		}
	}
}