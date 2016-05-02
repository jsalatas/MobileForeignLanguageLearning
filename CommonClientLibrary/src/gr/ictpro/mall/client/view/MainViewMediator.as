package gr.ictpro.mall.client.view
{
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.components.menu.MenuItem;
	import gr.ictpro.mall.client.components.menu.MenuItemSelected;
	import gr.ictpro.mall.client.model.NotificationModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.model.vo.Notification;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.GetTranslationsSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.MenuChangedSignal;
	import gr.ictpro.mall.client.signal.MenuClickedSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationClickedSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class MainViewMediator extends SignalMediator
	{
		[Inject]
		public var view:MainView;

		[Inject]
		public var menuClickedSignal:MenuClickedSignal;

		[Inject]
		public var saveSignal:SaveSignal;

		[Inject]
		public var serverNotificationClickedSignal:ServerNotificationClickedSignal;

		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var listSuccess:ListSuccessSignal;
		
		[Inject]
		public var listError:ListErrorSignal;

		[Inject]
		public var genericCall:GenericCallSignal;

		[Inject]
		public var notificationsModel:NotificationModel;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;
		
		[Inject]
		public var getTranslationsSignal:GetTranslationsSignal;
		
		[Inject]
		public var menuChangedSignal:MenuChangedSignal;

		override public function onRegister():void
		{
			addToSignal(view.menuClicked, menuClicked);
			addToSignal(view.classroomChanged, classroomChanged);
			addToSignal(view.notificationClicked, notificationClicked);
			addToSignal(view.notificationOkClicked, notificationOkClicked);
			addToSignal(view.switchAvailabilityClicked, switchAvailability);
			addToSignal(listSuccess, listSuccessHandler);
			addToSignal(listError, listErrorHandler);
			addToSignal(menuChangedSignal, menuChanged);
			view.user = settings.user;
			view.menu = settings.menu;
			view.notifications = notificationsModel.list;
			view.currentClassroomFormItem.visible = UserModel.isTeacher(settings.user) || UserModel.isStudent(settings.user);
			if(UserModel.isTeacher(settings.user)) {
				view.classrooms = settings.user.teacherClassrooms;
				view.currentClassroom.selected = settings.user.currentClassroom;
			} else if (UserModel.isStudent(settings.user)) {
				view.classrooms = settings.user.classrooms;
				view.currentClassroom.selected = settings.user.currentClassroom;
				view.currentClassroom.enabled = settings.user.currentClassroom == null;
			}  
		}
		
		private function listSuccessHandler(classType:Class):void
		{
			if(classType == Notification) {
				view.notifications = notificationsModel.list;
			} 
		}

		private function listErrorHandler(classType:Class, errorMessage:String):void
		{
			if(classType == Notification) {
				UI.showError(errorMessage);
			}
		}

		private function menuChanged():void
		{
			view.menu = settings.menu;
		}
		private function menuClicked(menuItem:MenuItem):void
		{
			menuClickedSignal.dispatch(new MenuItemSelected(menuItem));
			view.dispose();
		}
		
		private function notificationClicked(notification:Notification):void
		{
			serverNotificationClickedSignal.dispatch(notification);
			view.dispose();
		}

		private function notificationOkClicked(notification:Notification):void
		{
			saveSignal.dispatch(notification);
		}

		private function switchAvailability():void
		{
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = null;
			args.destination = "userRemoteService";
			args.method = "switchAvailability";
			args.type = "switchAvailability";
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);
			
		}

		private function classroomChanged():void
		{
			var classroom:Classroom = Classroom(view.currentClassroom.selected);
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = classroom;
			args.destination = "userRemoteService";
			args.method = "updateCurrentClassroom";
			args.type = "updateCurrentClassroom";
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);

		}

		private function success(type:String, result:Object):void
		{
			if(type == "updateCurrentClassroom") {
				removeSignals();
				settings.user.currentClassroom = Classroom(view.currentClassroom.selected);
				getTranslationsSignal.dispatch();
			} else if(type == "switchAvailability") {
				removeSignals();
				settings.user.available = !settings.user.available; 
			}
		}
		
		private function error(type:String, event:FaultEvent):void
		{
			if(type == "updateCurrentClassroom") {
				removeSignals();
				settings.user.currentClassroom = null;
			} else if(type == "switchAvailability") {
				removeSignals();
			}
		}
		
		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}


	}
}