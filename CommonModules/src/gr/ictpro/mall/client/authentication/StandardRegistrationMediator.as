package gr.ictpro.mall.client.authentication
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.model.RegistrationDetails;
	import gr.ictpro.mall.client.model.RoleModel;
	import gr.ictpro.mall.client.model.vo.Role;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
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
		public var listSuccessSignal:ListSuccessSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var roleModel:RoleModel;

		override public function onRegister():void
		{
			super.onRegister();
	
			addToSignal(view.okClicked, handleRegistration);
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
				view.roles = new ArrayCollection(roleModel.list.source);
				view.roles.removeItemAt(roleModel.getIndexByField("role", "Admin"));
				
				//Set default to student role
				var studentRole:Role = Role(roleModel.getItemByField("role", "Student"));
				view.role.selected = studentRole;
			}
		}
		
		private function error(event:FaultEvent):void
		{
			
		}
		private function handleRegistration():void
		{
			var password:String = view.txtPassword.text;
			var confirmPassword:String = view.txtConfirmPassword.text;
			if(password != confirmPassword) {
				UI.showError(view, Translation.getTranslation("Passwords do not Match."));
			} else {
				var userName:String = view.txtUserName.text;
				var name:String = view.txtName.text;
				var email:String = view.txtEmail.text;
				var role:int = view.role.selected.id;
				register.dispatch(new RegistrationDetails("standardRegistrationProvider",userName, name, password, email, role));
			}
		}
		
		private function handleRegisterFailed():void 
		{
			UI.showError(view, Translation.getTranslation("Cannot Register."));
		}

		private function handleRegisterSuccess():void 
		{
			view.dispose();
		}
	}
}