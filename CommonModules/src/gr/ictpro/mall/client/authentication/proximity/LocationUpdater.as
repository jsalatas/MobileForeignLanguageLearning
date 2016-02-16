package gr.ictpro.mall.client.authentication.proximity
{
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	
	import gr.ictpro.jsalatas.ane.wifitags.WifiTags;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.MessageReceivedSignal;

	public class LocationUpdater
	{
		[Inject]
		public var genericCallSignal:GenericCallSignal;

		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public var loginSuccessSignal:LoginSuccessSignal;
		

		[Inject]
		public function set messageReceivedSignal(messageReceivedSignal:MessageReceivedSignal):void
		{
			messageReceivedSignal.add(receiveMessage);
		}
		
		public function LocationUpdater()
		{
		}
		
		[PostConstruct]
		public function init():void
		{
			loginSuccessSignal.add(updateLocation);
		}
		
		private function receiveMessage(event:MessageEvent): void 
		{
			var subject:String = event.message.headers.Subject;
			if(subject == "Update Location") {
				if(UserModel.isTeacher(runtimeSettings.user) || UserModel.isAdmin(runtimeSettings.user)) {
					updateLocation();
				}
			}
		}
		
		public function updateLocation():void
		{
			var args:GenericServiceArguments = new GenericServiceArguments;
			args.type = "updateLocation";
			args.destination = "userRemoteService";
			args.method = "updateLocation";
			var w:WifiTags = new WifiTags();
			args.arguments = w.getWifiTags(); 
			if(args.arguments.ssids.length > 0) {
				genericCallSignal.dispatch(args);
			}
		}
		
	}
}