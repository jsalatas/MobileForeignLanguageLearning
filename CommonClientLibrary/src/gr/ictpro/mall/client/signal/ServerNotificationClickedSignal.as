package gr.ictpro.mall.client.signal
{
	import gr.ictpro.mall.client.model.vo.Notification;
	
	import org.osflash.signals.Signal;
	
	public class ServerNotificationClickedSignal extends Signal
	{
		public function ServerNotificationClickedSignal()
		{
			super(Notification);
		}
	}
}