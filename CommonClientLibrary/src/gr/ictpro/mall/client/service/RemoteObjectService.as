package gr.ictpro.mall.client.service
{
	import flash.text.ReturnKeyLabel;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;

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
			ro.channelSet = _channel.getChannelSet();
			ro.destination = _destination;
			ro.addEventListener(ResultEvent.RESULT, handleGenericResult);
			ro.addEventListener(FaultEvent.FAULT, handleGenericError);
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
			trace("Error: " + event);
			_handleError(event);
		}
		
	}
}