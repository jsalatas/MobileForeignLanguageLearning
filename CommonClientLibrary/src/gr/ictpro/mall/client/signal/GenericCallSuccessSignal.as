package gr.ictpro.mall.client.signal
{
	import org.osflash.signals.Signal;
	
	public class GenericCallSuccessSignal extends Signal
	{
		public function GenericCallSuccessSignal()
		{
			super(String, Object);
		}
	}
}