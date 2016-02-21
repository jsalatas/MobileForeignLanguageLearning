package gr.ictpro.mall.client.authentication.proximity
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.jsalatas.ane.wifitags.WifiTags;
	import gr.ictpro.mall.client.authentication.standard.StandardAuthentication;
	import gr.ictpro.mall.client.model.RegistrationDetails;
	import gr.ictpro.mall.client.model.RoleModel;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.model.vo.Role;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.service.AuthenticationProvider;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveErrorSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ProximityRegistrationMediator extends SignalMediator
	{
		[Inject]
		public var view:ProximityRegistration;
		
		[Inject]
		public var registrationFailed:RegisterFailedSignal;
		
		[Inject]
		public var registrationSuccess:RegisterSuccessSignal;
		
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
		public var serverConnectError:ServerConnectErrorSignal;

		[Inject]
		public var roleModel:RoleModel;
		
		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;
		
		[Inject]
		public var login:LoginSignal;

		[Inject]
		public var saveSignal:SaveSignal;

		[Inject]
		public var saveSucess:SaveSuccessSignal;

		[Inject]
		public var saveError:SaveErrorSignal;

		private var allDone:Boolean=false;
		override public function onRegister():void
		{
			super.onRegister();

			addToSignal(serverConnectError, serverError);
			addToSignal(view.okClicked, handleRegistration);
			addToSignal(view.cancelClicked, back);
			addToSignal(saveSucess, clientSaveSuccess);
			addToSignal(saveError, clientSaveError);
			addToSignal(listSuccessSignal, clientSaveSuccess);
			addToSignal(listErrorSignal, clientSaveError);
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
				register.dispatch(new RegistrationDetails("proximityRegistrationProvider",userName, name, password, email, role, relatedUser, getContextInfo()));
			}
		}

		
		private function getContextInfo():Object {
			var wifiTags:WifiTags = new WifiTags();
			var res:Object = wifiTags.getWifiTags();
			return res;
		}
		
		private function handleRegisterFailed():void 
		{
			UI.showError(Translation.getTranslation("Cannot Register."));
		}

		private function handleRegisterSuccess(enabled:Boolean):void 
		{
			// store username locally
			var setting:ClientSetting = new ClientSetting();
			setting.name = "lastUserName";
			setting.value = view.txtUserName.text;
			saveSignal.dispatch(setting);
		}
		
		private function serverError():void 
		{
			view.dispose();
		}

		private function clientSaveSuccess(classType:Class):void
		{
			if(classType == ClientSetting) {
				if(allDone) {
					authenticate();
				} else {
					allDone = true;
					//force refresh
					listSignal.dispatch(ClientSetting);
				}
			}
		}
		
		private function clientSaveError(classType:Class, errorMessage:String):void
		{
			if(classType == ClientSetting) {
				authenticate();
			}
		}

		private function authenticate():void
		{
			view.dispose();
			showAuthentication.dispatch(new AuthenticationProvider('/gr/ictpro/mall/client/authentication/proximity/Proximity.swf', 'gr.ictpro.mall.client.authentication.proximity.ProximityAuthentication'));
		}
	}
}