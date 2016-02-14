package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.components.menu.MenuItem;
	import gr.ictpro.mall.client.components.menu.MenuItemSelected;
	import gr.ictpro.mall.client.model.NotificationModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Notification;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
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
		public var notificationsModel:NotificationModel;
		
		override public function onRegister():void
		{
			addToSignal(view.menuClicked, menuClicked);
			addToSignal(view.notificationClicked, notificationClicked);
			addToSignal(view.notificationOkClicked, notificationOkClicked);
			addToSignal(listSuccess, listSuccessHandler);
			addToSignal(listError, listErrorHandler);
			view.user = settings.user;
			view.menu = settings.menu;
			view.notifications = notificationsModel.list;
			view.currentClassroomFormItem.visible = UserModel.isTeacher(settings.user) || UserModel.isStudent(settings.user);
			if(UserModel.isTeacher(settings.user)) {
				view.classrooms = settings.user.teacherClassrooms;
				view.currentClassroom.selected = settings.user.currentClassroom;
			} else if (UserModel.isStudent(settings.user)) {
				view.classrooms = settings.user.classrooms;
				view.currentClassroom.enabled = false;
				view.currentClassroom.selected = settings.user.currentClassroom;
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

	}
}