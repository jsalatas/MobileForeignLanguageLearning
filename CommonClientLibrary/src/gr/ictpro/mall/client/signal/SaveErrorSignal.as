package gr.ictpro.mall.client.signal
{
	import org.osflash.signals.Signal;
	
	public class SaveErrorSignal extends Signal
	{
		public function SaveErrorSignal()
		{
			super(Class, String);
		}
	}
}