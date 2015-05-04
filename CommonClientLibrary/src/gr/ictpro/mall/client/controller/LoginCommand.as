package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.ServerMessage;
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ShowMainViewSignal;
	
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoginCommand extends SignalCommand
	{
		[Inject]
		public var authenticationDetails:AuthenticationDetails;

		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var loginSuccess:LoginSuccessSignal;
		
		[Inject]
		public var loginFailed:LoginFailedSignal;
		
		[Inject]
		public var showMainView:ShowMainViewSignal;

		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var messagingService:MessagingService;
		
		override public function execute():void
		{
			var arguments:Object = new Object();
			arguments.username = authenticationDetails.username;
			arguments.credentials = authenticationDetails.credentials;
			arguments.authenticationMethod = authenticationDetails.authenticationMethod;
			var r: RemoteObjectService = new RemoteObjectService(channel, "authenticationRemoteService", "login", arguments, handleSuccess, handleError);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			var o:Object = event.result; 
			if(o == null) 
			{
				loginFailed.dispatch();
			} else {
				messagingService.init();
				loginSuccess.dispatch();
				var name:String;
				var photo:String;
				if(o.profile == null) {
					name = o.username;
					photo = null;
				} else {
					name = o.profile.name;
					photo = o.photo;
				}
				
				var roles:ArrayList = new ArrayList();
				for each (var role:Object in o.roles) {
					roles.addItem(role.role);
				}
				
				showMainView.dispatch(new User(o.id, o.username, o.email, roles, name, photo));
			}
		}
		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();			
		}
		
		
	}
}