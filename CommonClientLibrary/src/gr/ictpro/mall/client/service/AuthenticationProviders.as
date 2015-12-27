package gr.ictpro.mall.client.service
{
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	
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
			var className:String;
				if(previous == null) {
					provider = _authenticationProviders.getItemAt(0).ui.toString();
					className = _authenticationProviders.getItemAt(0).clientClassName.toString();
				} else {
					var pos:int = _authenticationProviders.getItemIndex(previous);
					
					if(pos == -1) {
						provider = null;
						className = null;
					} else {
						provider = _authenticationProviders.getItemAt(pos+1).ui.toString();
						className = _authenticationProviders.getItemAt(pos+1).clientClassName.toString();
					}
				}
				return new AuthenticationProvider(provider, className);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			_isInitialized = true;
			_authenticationProviders = ArrayCollection(event.result);
			showAuthentication.dispatch(new AuthenticationProvider(null, null));
		}

		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();
		}

	}
}