package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.model.menu.MenuItem;
	import gr.ictpro.mall.client.model.menu.MenuItemSelected;
	import gr.ictpro.mall.client.signal.MenuSignal;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;

		[Inject]
		public var menuSignal:MenuSignal;
		
		override public function onRegister():void
		{
			view.menuClicked.add(menuClicked);
		}
		
		private function menuClicked(menuItem:MenuItem):void
		{
			menuSignal.dispatch(new MenuItemSelected(menuItem));
			view.dispose();
		}
		
		
		
	}
}