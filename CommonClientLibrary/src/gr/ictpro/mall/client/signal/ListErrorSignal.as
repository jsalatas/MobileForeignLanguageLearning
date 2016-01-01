package gr.ictpro.mall.client.signal
{
	import org.osflash.signals.Signal;
	
	public class ListErrorSignal extends Signal
	{
		public function ListErrorSignal() 
		{
			super(Class, String);
		}
	}
}