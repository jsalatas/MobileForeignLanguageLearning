package gr.ictpro.mall.client.controller
{
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.ServerNotification;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class GetServerNotificationsCommand extends SignalCommand
	{
		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		override public function execute():void
		{
			var r: RemoteObjectService = new RemoteObjectService(channel, "notificationRemoteService", "getNotifications", null, handleSuccess, handleError);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			var o:Object = event.result;
			var notifications:ArrayList = new ArrayList();
			for each (var notificationObj:Object in o) {
				var notification:ServerNotification = new ServerNotification(notificationObj.id, notificationObj.date, notificationObj.subject, notificationObj.message, notificationObj.module, notificationObj.parameters, notificationObj.internalModule);
				notifications.addItem(notification);
			}
			settings.user.notifications = notifications;
		}
		
		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();
		}

	}
}