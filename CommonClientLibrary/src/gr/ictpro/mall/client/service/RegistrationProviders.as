package gr.ictpro.mall.client.service
{
	import gr.ictpro.mall.client.model.AuthenticationProvider;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.RegistrationProvider;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class RegistrationProviders
	{
		[Inject]
		public var channel:Channel;

		[Inject]
		public var showRegistration:ShowRegistrationSignal;

		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		

		private var _registrationProviders:ArrayCollection = null;
		private var _isInitialized:Boolean = false;

		public function RegistrationProviders()
		{
		}
		
		public function get isInitialized():Boolean
		{
			return this._isInitialized;
		}
		
		public function setupRegistrationProviders():void 
		{
			var r: RemoteObjectService = new RemoteObjectService(channel, "authenticationRemoteService", "getRegistrationModules", null, handleSuccess, handleError);
		}
		
		public function getNextProvider(previous:String):RegistrationProvider
		{
			var provider:String;
			
			if(previous == null) {
				provider = _registrationProviders.getItemAt(0).toString();
			} else {
				
				var pos:int = _registrationProviders.getItemIndex(previous);
				
				if(pos == -1) {
					provider = null;
				} else {
					provider = _registrationProviders.getItemAt(pos+1).toString();
				}
			}
			   return new RegistrationProvider(provider);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			_isInitialized = true;
			_registrationProviders = ArrayCollection(event.result);
			showRegistration.dispatch(new RegistrationProvider(null));
		}

		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();
		}

	}
}