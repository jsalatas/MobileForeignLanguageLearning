package gr.ictpro.mall.client.authentication.proximity
{
	import spark.events.PopUpEvent;
	
	import gr.ictpro.jsalatas.ane.wifitags.WifiTags;
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
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
		public var addonMenu:AddonMenu;

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
		public var clientSettingsModel:ClientSettingsModel;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		[Inject]
		public var locationUpdater:LocationUpdater;

		[Inject]
		public var saveSignal:SaveSignal;
		
		override public function onRegister():void
		{
			super.onRegister();

			addToSignal(loginSuccess, loggedIn);
			addToSignal(serverConnectError, serverError);
			addToSignal(view.okClicked, handleAuthentication);
			addToSignal(view.registerClicked, handleRegistration);
			
			// Check if we can get context info
			var contextInfo:Object = getContextInfo();
			if(contextInfo.ssids.length == 0) {
				// move to next provider
				showAuthentication.dispatch(authenticationProviders.getNextProvider("/gr/ictpro/mall/client/authentication/proximity/Proximity.swf"));
				view.dispose();
			} else {
				var lastUserName:String = clientSettingsModel.getItemById("lastUserName") != null?clientSettingsModel.getItemById("lastUserName").value:null;
				if(lastUserName != null) {
					autoLogin(lastUserName, contextInfo);
				}
			}
		}

		
		private function autoLogin(lastUserName:String, contextInfo:Object):void {
			var userName:String = lastUserName;
			var credentials:Object = new Object;
			credentials.password=null;
			credentials.contextInfo = contextInfo;
			
			login.dispatch(new AuthenticationDetails("proximityAuthenticationProvider", userName, credentials, true));

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
			var contextInfo:Object = getContextInfo();
			var credentials:Object = new Object;
			credentials.password = password;
			credentials.contextInfo = contextInfo.ssids.length == 0?null:contextInfo;
			
			login.dispatch(new AuthenticationDetails("proximityAuthenticationProvider", userName, credentials, false));
		}
		private function handleRegistration():void
		{
			addView.dispatch(new ProximityRegistration());
			view.dispose();
		}
		
		private function loggedIn():void 
		{
			// store username locally
			var setting:ClientSetting = new ClientSetting();
			setting.name = "lastUserName";
			setting.value = view.txtUserName.text;
			if(setting.value != null && setting.value != '') {
				// if is empty/null it means that it is an autologin, 
				// so the value is already in the database
				saveSignal.dispatch(setting);
			}

			var lastUserName:String = clientSettingsModel.getItemById("lastUserName") != null?clientSettingsModel.getItemById("lastUserName").value:null;
			if(lastUserName != null || (setting.value != null && setting.value != '')) {
				addonMenu.registerAddonMenu();				
			}
			// update current location
			locationUpdater.updateLocation();
			
			view.dispose();
		}

		private function serverError():void 
		{
			view.dispose();
		}

		protected function loginFailedPopup_close(event:PopUpEvent):void {
			view.txtUserName.text="";
			view.txtPassword.text="";
		}
		
		

	}
}