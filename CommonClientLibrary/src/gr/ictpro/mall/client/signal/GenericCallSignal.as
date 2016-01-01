package gr.ictpro.mall.client.signal
{
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	
	import org.osflash.signals.Signal;
	
	public class GenericCallSignal extends Signal
	{
		public function GenericCallSignal()
		{
			super(GenericServiceArguments);
		}
	}
}