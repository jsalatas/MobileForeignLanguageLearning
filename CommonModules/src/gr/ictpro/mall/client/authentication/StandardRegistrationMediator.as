package gr.ictpro.mall.client.authentication
{
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.RegistrationDetails;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.view.Notification;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	import spark.events.PopUpEvent;
	
	public class StandardRegistrationMediator extends ModuleMediator
	{
		[Inject]
		public var view:StandardRegistration;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var register:RegisterSignal;

		override public function onRegister():void
		{
			view.okClicked.add(handleRegistration);
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
			var studentRole:int = 0;
			view.roles = new ArrayCollection();
			for each (var role:Object in res) { 
				var o:Object = new Object;
				o.id = role.id;
				o.role = role.role;
				if(role.role == "Student") {
					studentRole = role.id;
				}
				view.roles.addItem(o);
			}
			view.role.selectedIndex = studentRole;
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
				passwordMismatchPopup.addEventListener(PopUpEvent.CLOSE, passwordMismatchPopup_close);
				passwordMismatchPopup.open(view, true);
			} else {
				var userName:String = view.txtUserName.text;
				var firstName:String = view.txtFirstName.text;
				var lastName:String = view.txtLastName.text;
				var email:String = view.txtEmail.text;
				var role:int = view.role.selectedItem.id;
				register.dispatch(new RegistrationDetails("standardRegistrationProvider",userName, firstName, lastName, password, email, role));
				
				//TODO
			}
		}
		
		private function passwordMismatchPopup_close(evt:PopUpEvent):void
		{
		}
	}
}