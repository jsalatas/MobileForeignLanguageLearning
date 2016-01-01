package gr.ictpro.mall.client.service
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	
	public class RegistrationProviders
	{
		private static var GET_REGISTRATION_PROVIDERS:String = "getRegistrationProviders";
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var showRegistration:ShowRegistrationSignal;

		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;
		
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
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = null;
			args.destination = "authenticationRemoteService";
			args.method = "getRegistrationModules";
			args.type = GET_REGISTRATION_PROVIDERS;
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);
		}
		
		public function getNextProvider(previous:String):RegistrationProvider
		{
			var provider:String;
			var className:String;
			
			if(previous == null) {
				provider = _registrationProviders.getItemAt(0).toString();
			} else {
				
				var pos:int = _registrationProviders.getItemIndex(previous);
				className = _registrationProviders.getItemAt(0).clientClassName.toString();
				
				if(pos == -1) {
					provider = null;
					className = null;
				} else {
					provider = _registrationProviders.getItemAt(pos+1).toString();
					className = _registrationProviders.getItemAt(pos+1).clientClassName.toString();
				}
			}
			   return new RegistrationProvider(provider, className);
		}
		
		private function success(type:String, result:Object):void
		{
			if(type == GET_REGISTRATION_PROVIDERS) {
				removeSignals();
				_isInitialized = true;
				_registrationProviders = ArrayCollection(result);
				showRegistration.dispatch(new RegistrationProvider(null, null));
			}
		}

		private function error(type:String, event:FaultEvent):void
		{
			if(type == GET_REGISTRATION_PROVIDERS) {
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