package gr.ictpro.mall.client.authentication.proximity
{
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ProximityAuthenticationMediator extends SignalMediator
	{
		[Inject]
		public var view:ProximityAuthentication;
		
		[Inject]
		public var login:LoginSignal;
		
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var showRegistration:ShowRegistrationSignal;
		
		[Inject]
		public var loginSuccess:LoginSuccessSignal;
		
		[Inject]
		public var loginFailed:LoginFailedSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		override public function onRegister():void
		{
			super.onRegister();

		}
	}
}