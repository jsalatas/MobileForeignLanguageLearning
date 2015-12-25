package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.ServerNotification;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.components.menu.MenuItem;
	import gr.ictpro.mall.client.components.menu.MenuItemSelected;
	import gr.ictpro.mall.client.signal.MenuClickedSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationClickedSignal;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;

		[Inject]
		public var menuClickedSignal:MenuClickedSignal;

		[Inject]
		public var serverNotificationClickedSignal:ServerNotificationClickedSignal;

		[Inject]
		public var settings:RuntimeSettings;

		override public function onRegister():void
		{
			view.menuClicked.add(menuClicked);
			view.notificationClicked.add(notificationClicked);
			view.user = settings.user;
		}
		
		private function menuClicked(menuItem:MenuItem):void
		{
			menuClickedSignal.dispatch(new MenuItemSelected(menuItem));
			view.dispose();
		}
		
		private function notificationClicked(notification:ServerNotification):void
		{
			serverNotificationClickedSignal.dispatch(notification);
			view.dispose();
		}
		
	}
}