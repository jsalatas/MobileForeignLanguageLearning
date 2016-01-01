package gr.ictpro.mall.client.signal
{
	import mx.rpc.events.FaultEvent;
	
	import org.osflash.signals.Signal;
	
	public class GenericCallErrorSignal extends Signal
	{
		public function GenericCallErrorSignal()
		{
			super(String, FaultEvent);
		}
	}
}