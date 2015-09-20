package gr.ictpro.mall.client.controller
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateServerNotificationsCommand extends SignalCommand
	{
		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		override public function execute():void
		{
			var r: RemoteObjectService = new RemoteObjectService(channel, "notificationRemoteService", "getNotifications", null, handleSuccess, handleError);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			var o:Object = event.result;
			

		}
		
		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();
		}

	}
}