package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.model.ServerNotification;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ServerNotificationHandledCommand extends SignalCommand
	{
		[Inject]
		public var notification:ServerNotification;
		
		override public function execute():void
		{
			//TODO: 
		}
		
	}
}