package gr.ictpro.mall.client.signal
{
	import org.osflash.signals.Signal;
	
	public class RegisterSuccessSignal extends Signal
	{
		public function RegisterSuccessSignal()
		{
			super(Boolean);
		}

	}
}