package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.model.ServerNotificationSelected;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ServerNotificationCommand extends SignalCommand
	{
		[Inject]
		public var selectedNotification:ServerNotificationSelected;

		override public function execute():void
		{
			trace(selectedNotification);
		}
	}
}