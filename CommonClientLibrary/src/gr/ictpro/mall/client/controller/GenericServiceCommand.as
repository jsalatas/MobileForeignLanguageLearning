package gr.ictpro.mall.client.controller
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class GenericServiceCommand extends SignalCommand
	{
		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var vo:GenericServiceArguments;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;
		
		override public function execute():void
		{
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = channel.getChannelSet();
			ro.destination = vo.destination;
			ro[vo.method].addEventListener(ResultEvent.RESULT, success);
			ro[vo.method].addEventListener(FaultEvent.FAULT, error);
			if(vo.arguments == null) {
				ro[vo.method].send();
			} else {
				ro[vo.method].send(vo.arguments);
			}
		}
		
		protected function success(event:ResultEvent):void
		{
			genericCallSuccess.dispatch(vo.type, event.result);
		}
		
		protected function error(event:FaultEvent):void
		{
			genericCallError.dispatch(vo.type, event);
		}

	}
}