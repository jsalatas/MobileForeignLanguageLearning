package gr.ictpro.mall.client.controller
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.RegistrationDetails;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class RegisterCommand extends SignalCommand
	{
		[Inject]
		public var registrationDetails:RegistrationDetails;
		
		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var registerSuccess:RegisterSuccessSignal;
		
		[Inject]
		public var registerFailed:RegisterFailedSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;
		
		[Inject]
		public var login:LoginSignal;

		override public function execute():void
		{
			var arguments:Object = new Object();
			arguments.userName=registrationDetails.userName;
			arguments.name=registrationDetails.name;
			arguments.password=registrationDetails.password;
			arguments.email=registrationDetails.email;
			arguments.role=registrationDetails.role;
			arguments.relatedUser=registrationDetails.relatedUser;
			arguments.languageCode=registrationDetails.language;
			arguments.contextInfo=registrationDetails.contextInfo;
			arguments.registrationMethod=registrationDetails.registrationMethod;
			
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = channel.getChannelSet();
			ro.destination = "userRemoteService";
			ro.register.addEventListener(ResultEvent.RESULT, success);
			ro.register.addEventListener(FaultEvent.FAULT, error);
			ro.register.send(arguments);

		}
		
		private function success(event:ResultEvent):void
		{
			var enabled:Boolean = Boolean(event.result);
			registerSuccess.dispatch(enabled);
//			if(enabled) {
//				// If Acoount is enabled then login automatically 
//				login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", registrationDetails.userName, registrationDetails.password, true));
//			}				
//			else {
//				//Return to login command
//				showAuthentication.dispatch();
//			}
		}
		
		private function error(event:FaultEvent):void
		{
			if(event.fault.faultString.indexOf("org.hibernate.exception.ConstraintViolationException") > -1) {
				registerFailed.dispatch();
			} else {
				serverConnectError.dispatch();
			}
		}
	}
}