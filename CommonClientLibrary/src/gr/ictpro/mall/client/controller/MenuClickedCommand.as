package gr.ictpro.mall.client.controller
{
	import flash.utils.getDefinitionByName;
	
	import gr.ictpro.mall.client.components.menu.MenuItemCommand;
	import gr.ictpro.mall.client.components.menu.MenuItemExternalModule;
	import gr.ictpro.mall.client.components.menu.MenuItemInternalModule;
	import gr.ictpro.mall.client.components.menu.MenuItemSelected;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	

	public class MenuClickedCommand extends SignalCommand
	{
		[Inject]
		public var selectedMenu:MenuItemSelected;

		[Inject]
		public var addView:AddViewSignal;
		
		override public function execute():void
		{
			if(selectedMenu.menuItem is MenuItemCommand)
			{
				(selectedMenu.menuItem as MenuItemCommand).execute();
			} else if(selectedMenu.menuItem is MenuItemInternalModule) {
				var classType:Class = (selectedMenu.menuItem as MenuItemInternalModule).classType; 
				addView.dispatch(new classType());
				
			} else if(selectedMenu.menuItem is MenuItemExternalModule) {
				//TODO: load external module				
			}
		}
		
	}
}