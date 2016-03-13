package gr.ictpro.mall.client.view
{
	import mx.rpc.events.FaultEvent;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	import gr.ictpro.mall.client.view.components.UserComponent;
	
	public class UserViewMediator extends TopBarDetailViewMediator
	{
		private static var GET_USER:String = "getUser";

		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;

		[Inject]
		public var saveSuccess:SaveSuccessSignal;

		[Inject]
		public var languageModel:LanguageModel;
		
		[Inject]
		public var listSuccessSignal:ListSuccessSignal;

		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public function set userModel(model:UserModel):void
		{
			super.model = model as AbstractModel;
		}
		

		override public function onRegister():void
		{
			super.onRegister();
			
			addToSignal(saveSuccess, saveSuccessHandler);
			addToSignal(listSuccessSignal, listSuccess);
			
			if(view.parameters == null || (view.parameters != null && view.parameters.initParams == null && view.parameters.vo == null)) {
				view.disableDelete(); // user cannot delete her own profile
				if(view.parameters == null) {
					view.parameters = new ViewParameters();
				}
				view.parameters.vo = settings.user;
				view.invalidateChildren();
				view.currentState = "profile";
			} else if(view.parameters.initParams != null && view.parameters.initParams.hasOwnProperty("user_id")) {
				if(UserModel.isParent(settings.user)) {
					view.currentState = "parentedit";
				} else {
					view.currentState = "edit";
				}
				getUser(view.parameters.initParams.user_id);
			} else if(view.parameters.vo != null) {
				if(UserModel(model).idIsNull(view.parameters.vo)) {
					view.currentState = "new";
					view.disableDelete();
				} else {
					if(UserModel.isParent(settings.user)) {
						view.currentState = "parentedit";
					} else {
						view.currentState = "edit";
					}
				}
			} else {
				throw new Error("Unknown User");
			}
			if(view.currentState != "parentedit") {
				listSignal.dispatch(Language);
			}

//			addToSignal(UserView(view).editor.choosePhoto, choosePhotoHandler);
		}
		
		private function listSuccess(classType:Class):void {
			if(classType == Language) {
				if(TopBarDetailView(view).editor != null) {
					TopBarDetailView(view).editor["languages"] = languageModel.getSortedListByFields([new SortField("englishName")]);
				}
			}
		}

		private function getUser(id:int):void
		{
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = new Object();
			args.arguments.id = id;
			args.destination = "userRemoteService";
			args.method = "getUser";
			args.type = GET_USER;
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);

		}
		
		private function success(type:String, result:Object):void
		{
			if(type == GET_USER) {
				removeSignals();
				if(result != null) {
					view.parameters.vo = result;
					view.invalidateChildren();
				} else {
					UI.showError("Cannot get User.");
					back();
				}
			}
		}
		
		private function error(type:String, event:FaultEvent):void
		{
			if(type == GET_USER) {
				removeSignals();
				UI.showError("Cannot get User.");
				back();
			}
		}
		
		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}
		
		override protected function beforeSaveHandler():void
		{
			var user:User = User(view.parameters.vo);
			if(!UserModel.isParent(settings.user)) {
				user.profile.image = UserComponent(TopBarDetailView(view).editor).imgPhoto;
				user.profile.color = UserComponent(TopBarDetailView(view).editor).popupColor.selected;
				user.profile.language =  Language(TopBarDetailView(view).editor["languagePopup"].selected);
			}

		}
		
		override protected function validateSave():Boolean
		{
			if(!UserModel.isParent(settings.user)) {
				var userView:UserComponent = UserComponent(TopBarDetailView(view).editor);
				if(userView.txtPassword.text != "" || userView.txtPassword2.text != "") {
					if(userView.txtPassword.text != userView.txtPassword2.text) {
						UI.showError("Passwords do not Match.");
						return false;
					} else {
						User(view.parameters.vo).password = userView.txtPassword.text; 
					}
				}
			}
			return true;
		}
		

		private function saveSuccessHandler(classType:Class):void
		{
			if(classType == User) {
				if(view.parameters == null) {
					// user edited his own profile
					settings.user = User(view.parameters.vo);
				}
			}
		}
	}
	
}