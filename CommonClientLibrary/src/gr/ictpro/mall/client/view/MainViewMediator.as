package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.ServerNotification;
	import gr.ictpro.mall.client.model.ServerNotificationSelected;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.menu.MenuItem;
	import gr.ictpro.mall.client.model.menu.MenuItemSelected;
	import gr.ictpro.mall.client.signal.MenuSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationSignal;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;

		[Inject]
		public var menuSignal:MenuSignal;

		[Inject]
		public var serverNotificationSignal:ServerNotificationSignal;

		[Inject]
		public var settings:Settings;

		override public function onRegister():void
		{
			view.menuClicked.add(menuClicked);
			view.notificationClicked.add(notificationClicked);
			view.user = settings.user;
		}
		
		private function menuClicked(menuItem:MenuItem):void
		{
			menuSignal.dispatch(new MenuItemSelected(menuItem));
			view.dispose();
		}
		
		private function notificationClicked(notification:ServerNotification):void
		{
			serverNotificationSignal.dispatch(new ServerNotificationSelected(notification));
			view.dispose();
		}
		
	}
}