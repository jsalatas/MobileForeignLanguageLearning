package gr.ictpro.mall.client.authentication.proximity
{
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	
	import gr.ictpro.mall.client.signal.MessageReceivedSignal;

	public class LocationUpdater
	{
		[Inject]
		public function set messageReceivedSignal(messageReceivedSignal:MessageReceivedSignal):void
		{
			messageReceivedSignal.add(receiveMessage);
		}
		
		public function LocationUpdater()
		{
			
		}
		
		private function receiveMessage(event:MessageEvent): void 
		{
			var subject:String = event.message.headers.Subject;
			if(subject == "Update Location") {
				updateLocation();
			}
		}
		
		private function updateLocation():void
		{
			//TODO:
		}
		
		private function error(e:MessageFaultEvent):void
		{
			trace(e);
		}

	}
}