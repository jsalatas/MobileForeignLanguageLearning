package gr.ictpro.mall.client.authentication
{
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.RegistrationProvider;
	import gr.ictpro.mall.client.model.ServerMessage;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
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
			
			// uncomment for testing purposes (fast login) 
			//login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", "admin", "admin"));
		}
		
		private function handleAuthentication():void
		{
			var userName:String = view.txtUserName.text;
			var password:String = view.txtPassword.text;

			login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", userName, password, false));
		}

		private function handleRegistration():void
		{
			disposeView();
			showRegistration.dispatch(new RegistrationProvider(null));
		}
		
		private function disposeView():void 
		{
			view.dispose();
			loginSuccess.removeAll();
			loginFailed.removeAll();
			serverConnectError.removeAll();

		}

		private function showFailedPopup():void 
		{
			var loginFailedPopup:PopupNotification = new PopupNotification();
			loginFailedPopup.message = Translation.getTranslation("Wrong User Name or Password.");
			
			loginFailedPopup.addEventListener(PopUpEvent.CLOSE, loginFailedPopup_close);
			loginFailedPopup.open(view, true);
		}
		
		protected function loginFailedPopup_close(event:PopUpEvent):void {
			view.txtUserName.text="";
			view.txtPassword.text="";
		}
		
		
	}
}