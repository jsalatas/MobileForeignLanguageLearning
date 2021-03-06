package gr.ictpro.mall.client.authentication.standard
{
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class StandardAuthenticationMediator extends SignalMediator
	{
		[Inject]
		public var view:StandardAuthentication;

		[Inject]
		public var login:LoginSignal;

		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var loginSuccess:LoginSuccessSignal;
		
		[Inject]
		public var loginFailed:LoginFailedSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		override public function onRegister():void
		{
			super.onRegister();

			addToSignal(loginSuccess, disposeView);
			addToSignal(loginFailed, showFailedPopup);
			addToSignal(serverConnectError, disposeView);
			addToSignal(view.okClicked, handleAuthentication);
			addToSignal(view.registerClicked, handleRegistration);

			// uncomment for testing purposes (fast login) 
			//login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", "admin", "12345", false));
		}

		private function handleAuthentication():void
		{
			var userName:String = view.txtUserName.text;
			var password:String = view.txtPassword.text;

			login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", userName, password, false));
		}

		private function handleRegistration():void
		{
			addView.dispatch(new StandardRegistration());
			disposeView();
		}
		
		private function disposeView():void 
		{
			view.dispose();
		}

		private function showFailedPopup():void 
		{
			UI.showError("Wrong User Name or Password.", loginFailedPopup_close);
		}
		
		protected function loginFailedPopup_close(event:PopUpEvent):void {
			view.txtUserName.text="";
			view.txtPassword.text="";
		}
		
		
	}
}