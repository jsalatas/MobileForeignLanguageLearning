package gr.ictpro.mall.client.authentication.proximity
{
	import spark.events.PopUpEvent;
	
	import gr.ictpro.jsalatas.ane.wifitags.WifiTags;
	import gr.ictpro.mall.client.authentication.standard.StandardRegistration;
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.service.AuthenticationProvider;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	
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
		public var loginSuccess:LoginSuccessSignal;

		[Inject]
		public var authenticationProviders:AuthenticationProviders;
		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;
		
		[Inject]
		public var loginFailed:LoginFailedSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		override public function onRegister():void
		{
			super.onRegister();

			addToSignal(loginSuccess, loggedIn);
			addToSignal(loginFailed, notLoggedIn);
			addToSignal(serverConnectError, loggedIn);
			addToSignal(view.okClicked, handleAuthentication);
			addToSignal(view.registerClicked, handleRegistration);
			
			// Check if we can get context info
			var contextInfo:Object = getContextInfo();
			if(contextInfo.ssids.length ==0) {
				notLoggedIn();
			}
				

		}

		private function getContextInfo():Object {
			var wifiTags:WifiTags = new WifiTags();
			var res:Object = wifiTags.getWifiTags();
			return res;
		}

		private function handleAuthentication():void
		{
			var userName:String = view.txtUserName.text;
			var password:String = view.txtPassword.text;
			
			login.dispatch(new AuthenticationDetails("proximityAuthenticationProvider", userName, password, false));
		}
		private function handleRegistration():void
		{
			addView.dispatch(new ProximityRegistration());
			view.dispose();
		}
		
		private function loggedIn():void 
		{
			// TODO: store username locally
			view.dispose();
		}
		
		private function notLoggedIn():void 
		{
			// move to next provider
			showAuthentication.dispatch(authenticationProviders.getNextProvider("/gr/ictpro/mall/client/authentication/proximity/Proximity.swf"));
			view.dispose();
		}
		
		protected function loginFailedPopup_close(event:PopUpEvent):void {
			view.txtUserName.text="";
			view.txtPassword.text="";
		}
		
		

	}
}