package gr.ictpro.mall.client.authentication
{
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.RegistrationProvider;
	import gr.ictpro.mall.client.model.ServerMessage;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	import gr.ictpro.mall.client.view.Notification;
	
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	import spark.events.PopUpEvent;
	
	public class StandardAuthenticationMediator extends ModuleMediator
	{
		[Inject]
		public var view:StandardAuthentication;

		[Inject]
		public var login:LoginSignal;

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
			loginSuccess.add(disposeView);
			loginFailed.add(showFailedPopup);
			serverConnectError.add(disposeView);
			view.okClicked.add(handleAuthentication);
			view.registerClicked.add(handleRegistration);
		}
		
		private function handleAuthentication():void
		{
			var userName:String = view.txtUserName.text;
			var password:String = view.txtPassword.text;

			login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", userName, password));
		}

		private function handleRegistration():void
		{
			view.dispose();
			showRegistration.dispatch(new RegistrationProvider(null));
		}
		
		private function disposeView():void 
		{
			view.dispose();
		}

		private function showFailedPopup():void 
		{
			var loginFailedPopup:Notification = new Notification();
			loginFailedPopup.message = "Wrong User name or Password.";
			
			loginFailedPopup.addEventListener(PopUpEvent.CLOSE, loginFailedPopup_close);
			loginFailedPopup.open(view, true);
		}
		
		protected function loginFailedPopup_close(eventt:PopUpEvent):void {
			view.txtUserName.text="";
			view.txtPassword.text="";
		}
		
		
	}
}