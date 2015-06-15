package gr.ictpro.mall.client.authentication
{
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.RegistrationDetails;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.components.Notification;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	import spark.events.PopUpEvent;
	
	public class StandardRegistrationMediator extends ModuleMediator
	{
		[Inject]
		public var view:StandardRegistration;
		
		[Inject]
		public var registrationFailed:RegisterFailedSignal;
		
		[Inject]
		public var registrationSuccess:RegisterSuccessSignal;

		[Inject]
		public var channel:Channel;

		[Inject]
		public var register:RegisterSignal;

		override public function onRegister():void
		{
			view.okClicked.add(handleRegistration);
			registrationFailed.add(handleRegisterFailed);
			registrationSuccess.add(handleRegisterSuccess);
			getRoles();
		}		

		private function getRoles():void
		{
			var r: RemoteObjectService = new RemoteObjectService(channel, "authenticationRemoteService", "getRoles", null, handleSuccess, handleError);
			
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			//view.roles = ArrayCollection(event.result);
			var res:ArrayCollection = ArrayCollection(event.result);
			var studentRole:ObjectProxy;
			view.roles = new ArrayList();
			for each (var role:Object in res) { 
				var o:ObjectProxy = new ObjectProxy;
				o.id = role.id;
				o.text = role.role;
				o.image = null; 
				if(role.role == "Student") {
					studentRole = o;
				}
				view.roles.addItem(o);
			}
			view.role.selected = studentRole;
		}
		
		private function handleError(event:FaultEvent):void
		{
			//TODO: 
		}
		private function handleRegistration():void
		{
			var password:String = view.txtPassword.text;
			var confirmPassword:String = view.txtConfirmPassword.text;
			if(password != confirmPassword) {
				var passwordMismatchPopup:Notification = new Notification();
				passwordMismatchPopup.message = "Passwords do not match.";
				//passwordMismatchPopup.addEventListener(PopUpEvent.CLOSE, popup_close);
				passwordMismatchPopup.open(view, true);
			} else {
				var userName:String = view.txtUserName.text;
				var name:String = view.txtName.text;
				var email:String = view.txtEmail.text;
				var role:int = view.role.selected.id;
				register.dispatch(new RegistrationDetails("standardRegistrationProvider",userName, name, password, email, role));
				
				//TODO
			}
		}
		
//		private function popup_close(evt:PopUpEvent):void
//		{
//		}
		
		private function handleRegisterFailed():void 
		{
			var registerFailedPopup:Notification = new Notification();
			registerFailedPopup.message = "Cannot register.";
			//passwordMismatchPopup.addEventListener(PopUpEvent.CLOSE, popup_close);
			registerFailedPopup.open(view, true);
		}

		private function handleRegisterSuccess():void 
		{
			view.dispose();
			registrationFailed.removeAll();
			registrationSuccess.removeAll();
		}
	}
}