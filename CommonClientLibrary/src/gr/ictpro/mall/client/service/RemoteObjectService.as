package gr.ictpro.mall.client.service
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	public class RemoteObjectService
	{
		private var _channel:Channel;
		private var _destination:String; 
		private var _methodName:String;
		private var _handleResult:Function;
		private var _handleError:Function;
		private var _arguments:Object;
		private var _serverConnectError:ServerConnectErrorSignal;
		
		public function RemoteObjectService(channel:Channel, destination:String, methodName:String, arguments:Object, handleResult:Function, handleError:Function)
		{
			this._channel = channel;
			this._destination = destination;
			this._methodName = methodName;
			this._arguments = arguments;
			this._handleResult = handleResult;
			this._handleError = handleError;
			execute();				
		}

		private function execute():void
		{
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = _channel.getChannelSet();
			ro.destination = _destination;
			ro[_methodName].addEventListener(ResultEvent.RESULT, handleGenericResult);
			ro[_methodName].addEventListener(FaultEvent.FAULT, handleGenericError);
			if(_arguments == null) {
				ro[_methodName].send();
			} else {
				ro[_methodName].send(_arguments);
			}
			
		}
		
		private function handleGenericResult(event:ResultEvent):void
		{
			_handleResult(event);
		}

		private function handleGenericError(event:FaultEvent):void
		{
			_handleError(event);
		}
		
	}
}