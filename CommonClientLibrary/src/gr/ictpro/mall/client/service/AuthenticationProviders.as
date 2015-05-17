package gr.ictpro.mall.client.service
{
	import flash.text.ReturnKeyLabel;
	
	import gr.ictpro.mall.client.model.AuthenticationProvider;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class AuthenticationProviders
	{
		[Inject]
		public var channel:Channel;

		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;

		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		

		private var _authenticationProviders:ArrayCollection = null;
		private var _isInitialized:Boolean = false;
		
		public function AuthenticationProviders()
		{
		}
		
		public function get isInitialized():Boolean
		{
			return this._isInitialized;
		}
		
		public	function setupAuthenticationProviders():void 
		{
			new RemoteObjectService(channel, "authenticationRemoteService", "getAuthenticationModules", null, handleSuccess, handleError);
		}
		
		public function getNextProvider(previous:String):AuthenticationProvider
		{
			var provider:String;
				if(previous == null) {
					provider = _authenticationProviders.getItemAt(0).toString();
				} else {
					
					var pos:int = _authenticationProviders.getItemIndex(previous);
					
					if(pos == -1) {
						provider = null;
					} else {
						provider = _authenticationProviders.getItemAt(pos+1).toString();
					}
				}
				return new AuthenticationProvider(provider);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			_isInitialized = true;
			_authenticationProviders = ArrayCollection(event.result);
			showAuthentication.dispatch(new AuthenticationProvider(null));
		}

		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();
		}

	}
}