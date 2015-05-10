package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.model.menu.MenuItem;
	import gr.ictpro.mall.client.model.menu.MenuItemCommand;
	import gr.ictpro.mall.client.model.menu.MenuItemSelected;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class MenuCommand extends SignalCommand
	{
		[Inject]
		public var selectedMenu:MenuItemSelected;

		override public function execute():void
		{
			if(selectedMenu.menuItem is MenuItemCommand)
			{
				(selectedMenu.menuItem as MenuItemCommand).execute();
			} else 
			{
				trace("Go to: " + selectedMenu.menuItem.text);
			}

		}
	}
}