package gr.ictpro.mall.client.authentication.standard
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.model.AuthenticationDetails;
	import gr.ictpro.mall.client.model.RegistrationDetails;
	import gr.ictpro.mall.client.model.RoleModel;
	import gr.ictpro.mall.client.model.vo.Role;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.service.AuthenticationProvider;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class StandardRegistrationMediator extends SignalMediator
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

		[Inject]
		public var listSignal:ListSignal;

		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var listSuccessSignal:ListSuccessSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var roleModel:RoleModel;

		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;
		
		[Inject]
		public var login:LoginSignal;

		override public function onRegister():void
		{
			super.onRegister();
	
			addToSignal(view.okClicked, handleRegistration);
			addToSignal(view.cancelClicked, back);
			addToSignal(registrationFailed, handleRegisterFailed);
			addToSignal(registrationSuccess, handleRegisterSuccess);
			getRoles();
		}		

		private function getRoles():void
		{
			addToSignal(listSuccessSignal, success);
			addToSignal(listErrorSignal, error);
			listSignal.dispatch(Role);
			
		}
		
		private function success(classType:Class):void
		{
			if(classType == Role) {
				view.roles = new ArrayCollection();
				for each (var role:Role in roleModel.list.source) {
					if(role.role != "Admin") {
						view.roles.addItem(role);
					}
				}
				
				//Set default to student role
				var studentRole:Role = Role(roleModel.getItemByField("role", "Student"));
				view.role.selected = studentRole;
			}
		}
		
		private function error(event:FaultEvent):void
		{
			
		}

		private function back():void
		{
			view.dispose();
			addView.dispatch(new StandardAuthentication());
		}
		
		private function handleRegistration():void
		{
			var password:String = view.txtPassword.text;
			var confirmPassword:String = view.txtConfirmPassword.text;
			if(password != confirmPassword) {
				UI.showError(Translation.getTranslation("Passwords do not Match"));
			} else {
				var userName:String = view.txtUserName.text;
				var name:String = view.txtName.text;
				var email:String = view.txtEmail.text;
				var role:int = view.role.selected.id;
				var relatedUser:String = view.txtRelatedUser.text;
				if(userName == null) {
					UI.showError(Translation.getTranslation("Enter your Username"));
				} else if(name==null) {
					UI.showError(Translation.getTranslation("Enter your Name"));
				} else if(email==null) {
					UI.showError(Translation.getTranslation("Enter your Email"));
				} else if(relatedUser==null && role == 3) {
					UI.showError(Translation.getTranslation("Enter your Teacher's Username. If you don't know it please ask your teacher."));
				}					
				register.dispatch(new RegistrationDetails("standardRegistrationProvider",userName, name, password, email, role, relatedUser, null));
			}
		}
		
		private function handleRegisterFailed():void 
		{
			UI.showError(Translation.getTranslation("Cannot Register."));
		}

		private function handleRegisterSuccess(enabled:Boolean):void 
		{
			view.dispose();
			if(enabled) {
				var password:String = view.txtPassword.text;
				var userName:String = view.txtUserName.text;
				// If Acoount is enabled then login automatically 
				login.dispatch(new AuthenticationDetails("standardAuthenticationProvider", userName, password, true));
			}				
			else {
				//Return to login command
				showAuthentication.dispatch(new AuthenticationProvider('/gr/ictpro/mall/client/authentication/standard/Standard.swf', 'gr.ictpro.mall.client.authentication.standard.StandardAuthentication'));
			}

		}
	}
}