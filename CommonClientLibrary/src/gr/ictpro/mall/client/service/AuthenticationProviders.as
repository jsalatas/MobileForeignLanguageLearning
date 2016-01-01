package gr.ictpro.mall.client.service
{
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	
	public class AuthenticationProviders
	{
		private static var GET_AUTHENTICATION_PROVIDERS:String = "getAuthenticationProviders";

		[Inject]
		public var channel:Channel;

		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;

		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;
		
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
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = null;
			args.destination = "authenticationRemoteService";
			args.method = "getAuthenticationModules";
			args.type = GET_AUTHENTICATION_PROVIDERS;
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);
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
		
		private function success(type:String, result:Object):void
		{
			if(type == GET_AUTHENTICATION_PROVIDERS) {
				removeSignals();
				_isInitialized = true;
				_authenticationProviders = ArrayCollection(result);
				showAuthentication.dispatch(new AuthenticationProvider(null, null));
			}
		}

		private function error(type:String, event:FaultEvent):void
		{
			if(type == GET_AUTHENTICATION_PROVIDERS) {
				removeSignals();
				serverConnectError.dispatch();
			}
		}
		
		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}
	}
}