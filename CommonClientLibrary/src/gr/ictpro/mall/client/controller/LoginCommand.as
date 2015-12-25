package gr.ictpro.mall.client.controller
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.service.Modules;
	import gr.ictpro.mall.client.model.ServerConfiguration;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.UpdateServerNotificationsSignal;
	import gr.ictpro.mall.client.view.MainView;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoginCommand extends SignalCommand
	{
		[Inject]
		public var authenticationDetails:AuthenticationDetails;

		[Inject]
		public var channel:Channel;

		[Inject]
		public var loadedModule:Modules;

		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var loginSuccess:LoginSuccessSignal;
		
		[Inject]
		public var loginFailed:LoginFailedSignal;
		
		[Inject]
		public var settings:Settings;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var messagingService:MessagingService;

		[Inject]
		public var updateServerNotifications:UpdateServerNotificationsSignal;
		

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
				if(!authenticationDetails.autoLogin) {
					loginFailed.dispatch();
				} else {
					//TODO:
				}
			} else {
				messagingService.init();
				loginSuccess.dispatch();
				
				settings.user = User.createUser(o);
				injector.injectInto(settings.user);
				
				settings.user.initializeMenu();
				if(settings.user.isAdmin) {
					settings.serverConfiguration = new ServerConfiguration(channel);
				}
				loadedModule.module = null;
				updateServerNotifications.dispatch();
				addView.dispatch(new MainView());
			}
		}
		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();			
		}
		
		
	}
}