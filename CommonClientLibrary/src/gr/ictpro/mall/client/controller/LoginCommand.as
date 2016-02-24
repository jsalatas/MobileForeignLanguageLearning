package gr.ictpro.mall.client.controller
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.vo.Notification;
	import gr.ictpro.mall.client.model.vo.Role;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.GetTranslationsSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.view.MainView;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoginCommand extends SignalCommand
	{
		[Inject]
		public var authenticationDetails:AuthenticationDetails;

		[Inject]
		public var channel:Channel;

		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var loginSuccess:LoginSuccessSignal;
		
		[Inject]
		public var loginFailed:LoginFailedSignal;
		
		[Inject]
		public var getTranslationsSignal:GetTranslationsSignal;
		
		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var mainMenu:MainMenu;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var messagingService:MessagingService;

		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public var listSuccessSignal:ListSuccessSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var genericCallSuccessSignal:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallErrorSignal:GenericCallErrorSignal;
		

		override public function execute():void
		{
			var arguments:Object = new Object();
			arguments.username = authenticationDetails.username;
			arguments.credentials = authenticationDetails.credentials;
			arguments.authenticationMethod = authenticationDetails.authenticationMethod;
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = channel.getChannelSet();
			ro.destination = "authenticationRemoteService";
			ro.login.addEventListener(ResultEvent.RESULT, success);
			ro.login.addEventListener(FaultEvent.FAULT, error);
			ro.login.send(arguments);
		}
		
		private function success(event:ResultEvent):void
		{
			var user:User = User(event.result); 
			if(user == null) 
			{
				if(!authenticationDetails.autoLogin) {
					loginFailed.dispatch();
				} else {
					//TODO:
				}
			} else {
				messagingService.init();
				settings.user = user;
				if(user.currentClassroom != null) {
					getTranslationsSignal.dispatch();
				}
				listSuccessSignal.add(listSuccess);
				listErrorSignal.add(listError);
				listSignal.dispatch(Role);
			}
		}
		
		private function listSuccess(classType:Class):void
		{
			if(classType == Role) {
				settings.menu = mainMenu.getMenu(settings.user);
				listSignal.dispatch(Notification);
			}
			if(classType == Notification) {
				listSuccessSignal.remove(listSuccess);
				listErrorSignal.remove(listError);
				addView.dispatch(new MainView());

				loginSuccess.dispatch();
			}

		}

		private function listError(classType:Class, errorMessage:String):void
		{
			if(classType == Role || classType == Notification) {
				listSuccessSignal.remove(listSuccess);
				listErrorSignal.remove(listError);
				serverConnectError.dispatch();			
			}

		}

		private function error(event:FaultEvent):void
		{
			serverConnectError.dispatch();			
		}
		
		
	}
}