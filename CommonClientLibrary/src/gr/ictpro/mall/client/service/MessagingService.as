package gr.ictpro.mall.client.service
{
	import gr.ictpro.mall.client.model.Channel;
	
	import mx.messaging.Consumer;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.AsyncMessage;

	public class MessagingService
	{
		[Inject]
		public var channel:Channel;
		
		private var consumer:Consumer = new Consumer();
		
		public function MessagingService()
		{
		}
		
		public function init(): void
		{
			consumer.destination = "messages";
			consumer.channelSet = channel.getMessagingChannelSet();
			consumer.subscribe();
			consumer.addEventListener(MessageEvent.MESSAGE, receiveMessage);
			
		}

		private function receiveMessage(event:MessageEvent): void 
		{
			trace(event.message.body);
		}
	}
}