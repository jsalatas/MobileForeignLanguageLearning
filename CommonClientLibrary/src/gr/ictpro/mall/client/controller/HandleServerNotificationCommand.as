package gr.ictpro.mall.client.controller
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.ServerNotification;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.GetServerNotificationsSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class HandleServerNotificationCommand extends SignalCommand
	{
		[Inject]
		public var notification:ServerNotification;

		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var updateServerNotifications:GetServerNotificationsSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		override public function execute():void
		{
			var arguments:Object = new Object();
			arguments.id = notification.id;
			var r: RemoteObjectService = new RemoteObjectService(channel, "notificationRemoteService", "handleNotification", arguments, handleSuccess, handleError);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			updateServerNotifications.dispatch();
		}

		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();			
		}
		
	}
}