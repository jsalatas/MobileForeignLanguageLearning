package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.MeetingModel;
	import gr.ictpro.mall.client.model.MeetingTypeModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.model.vo.MeetingType;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	import gr.ictpro.mall.client.view.components.MeetingComponent;

	public class MeetingViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public var listSignal:ListSignal;

		[Inject]
		public var listSuccessSignal:ListSuccessSignal;

		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public var meetingTypeModel:MeetingTypeModel;

		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;
		
		[Inject]
		public function set meetingModel(model:MeetingModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			MeetingModel(model).addFilter = filterAvailableUsers;
			if(view.parameters != null && view.parameters.initParams != null && view.parameters.initParams.meeting_id != null) {
				getMeeting(view.parameters.initParams.meeting_id);
			} else{
				init();
			}
		}
		
		private function init():void {
			TopBarDetailView(view).editor["currentUserIsStudent"] = UserModel.isStudent(runtimeSettings.user);
			if(view.currentState == "new") {
				TopBarDetailView(view).editor.vo.approve = UserModel.isAdmin(runtimeSettings.user) || UserModel.isTeacher(runtimeSettings.user);
			}
			var yesterday:Date = new Date(); 
			yesterday.date -= 1;
			var meetingComponent:MeetingComponent = MeetingComponent(TopBarDetailView(view).editor);
			if (meetingComponent.vo.time != null && meetingComponent.vo.time<yesterday) {
				TopBarDetailView(view).disableOK();
				TopBarDetailView(view).disableDelete();
			}
			if (!UserModel.isAdmin(runtimeSettings.user) && !UserModel.isTeacher(runtimeSettings.user) && meetingComponent.vo.createdBy != null && meetingComponent.vo.createdBy.id != runtimeSettings.user.id) {
				meetingComponent.enabled = false;
				view.disableDelete();
			}
			addToSignal(listSuccessSignal, listSuccess);
			addToSignal(MeetingComponent(TopBarDetailView(view).editor).timeChangedSignal, removeUnavailableUsers);
			addToSignal(MeetingComponent(TopBarDetailView(view).editor).btnJoinClickedSignal, joinMeetingHandler);
			listSignal.dispatch(MeetingType);
		}
		private function getMeeting(id:int):void
		{
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = new Object();
			args.arguments.id = id;
			args.destination = "meetingRemoteService";
			args.method = "getMeeting";
			args.type = "get_meeting";
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);
		}
		
		private function success(type:String, result:Object):void
		{
			if(type == "get_meeting") {
				removeSignals();
				if(result != null) {
					view.parameters.vo = result;
					view.invalidateChildren();
					init();
				} else {
					UI.showError("Cannot get Meeting.");
					back();
				}
			}
		}
		
		private function error(type:String, event:FaultEvent):void
		{
			if(type == "get_meeting") {
				removeSignals();
				UI.showError("Cannot get Meeting.");
				back();
			}
		}

		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}

		public function filterAvailableUsers(item:User):Boolean {
			if(UserModel.isStudent(runtimeSettings.user)) {
				if(item.disallowUnattendedMeetings) {
					return false;
				}
				if(!UserModel.isStudent(item)) {
					return false;
				}
			}
			
			if(item.id == runtimeSettings.user.id) {
				return false;
			}
			var meetingComponent:MeetingComponent = MeetingComponent(TopBarDetailView(view).editor);
			if(meetingComponent.time.date == null) {
				//now 
				return item.available && item.online;
			} 
			return true;
		}	
		
		private function joinMeetingHandler():void
		{
			var bbbMeetingView:BBBMeetingView = new BBBMeetingView();
			var parameters:ViewParameters = new ViewParameters();
			parameters.vo = MeetingComponent(TopBarDetailView(view).editor).vo;
			addView.dispatch(bbbMeetingView, parameters, view);
			view.dispose();

			
		}
		
		public function removeUnavailableUsers():void {
			var currentUsers:ArrayCollection = TopBarDetailView(view).getDetail("users").list;
			var toRemove:ArrayCollection = new ArrayCollection();
			var meetingComponent:MeetingComponent = MeetingComponent(TopBarDetailView(view).editor);
			if(meetingComponent.chkNow.selected) {
				for each (var user:User in currentUsers) {
					if(!filterAvailableUsers(user)) {
						toRemove.addItem(user);
					}
				}
				
				for each (var user1:User in toRemove) {
					currentUsers.removeItemAt(currentUsers.getItemIndex(user1));
				}
			}
		}
		
		override protected function validateSave():Boolean {
			var meetingComponent:MeetingComponent = MeetingComponent(TopBarDetailView(view).editor);
			var now:Date = new Date();
			if(meetingComponent.vo.time != null && meetingComponent.vo.time < now) {
				UI.showError("Please Select a Valid Date.");
				return false; 
			}
			
			if(meetingComponent.vo.meetingType == null) {
				UI.showError("Please Select a Meeting Type.");
				return false; 
			}
			if(meetingComponent.vo.name == null || meetingComponent.vo.name == '') {
				UI.showError("Please Enter a Name.");
				return false; 
			}
			
			if(meetingComponent.vo.users.length < 2) {
				UI.showError("Please Add at aleast one other User.");
				return false; 
			}
			
			return true;
		}
		
		override protected function beforeSaveHandler():void {
			var meetingComponent:MeetingComponent = MeetingComponent(TopBarDetailView(view).editor);
			if(meetingComponent.chkNow.selected) {
				meetingComponent.vo.time = null;
			} else {
				meetingComponent.vo.time =meetingComponent.time.date;
			}
			meetingComponent.vo.name = meetingComponent.txtName.text;
			
			if(view.currentState == "new") {
				meetingComponent.vo.users.addItem(runtimeSettings.user);
			}
			meetingComponent.vo.meetingType = meetingComponent.meetingTypePopup.selected;
			
		}
		
		private function listSuccess(classType:Class):void {
			if(classType == MeetingType) {
				TopBarDetailView(view).editor["meetingTypes"] = meetingTypeModel.list;
			}
		}
	}
}