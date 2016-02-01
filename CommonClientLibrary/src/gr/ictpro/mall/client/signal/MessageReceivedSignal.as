package gr.ictpro.mall.client.signal
{
	import mx.messaging.events.MessageEvent;
	
	import org.osflash.signals.Signal;
	
	public class MessageReceivedSignal extends Signal
	{
		public function MessageReceivedSignal()
		{
			super(MessageEvent);
		}
	}
}