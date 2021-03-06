package gr.ictpro.mall.client.service
{
	import flash.utils.getDefinitionByName;
	
	import mx.messaging.Consumer;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.MessageReceivedSignal;

	public class MessagingService
	{
		[Inject]
		public var channel:Channel;

		[Inject]
		public var settings:RuntimeSettings;
		
		[Inject]
		public var listSignal:ListSignal;

		[Inject]
		public var messageReceivedSignal:MessageReceivedSignal;

		[Inject]
		public var mapper:VOMapper;

		private var consumer:Consumer = new Consumer();
		
		public function MessagingService()
		{
		}
		
		public function init(): void
		{
			consumer.destination = "messages";
			consumer.channelSet = channel.getMessagingChannelSet();
			consumer.addEventListener(MessageEvent.MESSAGE, receiveMessage);
			consumer.addEventListener(FaultEvent.FAULT, error);
			consumer.subscribe();
		}

		private function error(e:MessageFaultEvent):void
		{
			trace(e);
		}
			
		private function receiveMessage(event:MessageEvent): void 
		{
			var subject:String = event.message.headers.Subject;
			//Debug
			switch(subject)
			{
				case "Refresh Data":
				{
					var params:Object = event.message.headers.Parameters;
					var classType:Class = Class(getDefinitionByName(params.className));
					var model:AbstractModel = mapper.getModelforVO(classType);
					// removing all elements from the list will force it to refresh 
					// from the server when dispatching the listSignal
					//model.list.removeAll();
					model.forceRefresh = true;
					listSignal.dispatch(classType);
					break;
				}
					
				default:
				{
					messageReceivedSignal.dispatch(event);
				}
			}
		}
	}
}