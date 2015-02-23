package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.RegistrationDetails;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
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
		public var login:LoginSignal;

		override public function execute():void
		{
			var arguments:Object = new Object();
			arguments.userName=registrationDetails.userName;
			arguments.firstName=registrationDetails.firstName;
			arguments.lastName=registrationDetails.lastName;
			arguments.password=registrationDetails.password;
			arguments.email=registrationDetails.email;
			arguments.role=registrationDetails.role;
			arguments.registrationMethod=registrationDetails.registrationMethod;
			
			var r: RemoteObjectService = new RemoteObjectService(channel, "userRemoteService", "register", arguments, handleSuccess, handleError);
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			var o:Object = event.result;
			// TODO: check if user is able to login? 
			login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", registrationDetails.userName, registrationDetails.password));
		}
		
		private function handleError(event:FaultEvent):void
		{
			serverConnectError.dispatch();			
		}
	}
}