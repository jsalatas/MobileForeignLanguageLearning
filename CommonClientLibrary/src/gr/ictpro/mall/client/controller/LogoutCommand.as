package gr.ictpro.mall.client.controller
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.Channel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LogoutCommand extends SignalCommand
	{
		[Inject]
		public var channel:Channel;

		[Inject]
		public var runtimeSettings:RuntimeSettings;

		override public function execute():void
		{
			var arguments:Object = new Object();
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = channel.getChannelSet();
			ro.destination = "authenticationRemoteService";
			ro.terminateSession.addEventListener(ResultEvent.RESULT, success);
			ro.terminateSession.addEventListener(FaultEvent.FAULT, error);
			ro.terminateSession.send();
		}
		
		private function success(event:ResultEvent):void
		{
			runtimeSettings.terminate();
		}
		
		private function error(event:FaultEvent):void
		{
			runtimeSettings.terminate();
		}
	}
}