package gr.ictpro.mall.client.signal
{
	import org.osflash.signals.Signal;
	
	public class DeleteErrorSignal extends Signal
	{
		public function DeleteErrorSignal() 
		{
			super(Class, String);
		}
	}
}