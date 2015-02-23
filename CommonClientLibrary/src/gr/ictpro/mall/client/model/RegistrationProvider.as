package gr.ictpro.mall.client.model
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