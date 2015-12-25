package gr.ictpro.mall.client.controller
{
	import flash.utils.getDefinitionByName;
	
	import gr.ictpro.mall.client.service.Modules;
	import gr.ictpro.mall.client.components.menu.MenuItemCommand;
	import gr.ictpro.mall.client.components.menu.MenuItemExternalModule;
	import gr.ictpro.mall.client.components.menu.MenuItemInternalModule;
	import gr.ictpro.mall.client.components.menu.MenuItemSelected;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	

	public class MenuCommand extends SignalCommand
	{
		[Inject]
		public var selectedMenu:MenuItemSelected;

		[Inject]
		public var loadedModules:Modules;

		[Inject]
		public var addView:AddViewSignal;
		
		override public function execute():void
		{
			if(selectedMenu.menuItem is MenuItemCommand)
			{
				(selectedMenu.menuItem as MenuItemCommand).execute();
			} else if(selectedMenu.menuItem is MenuItemInternalModule) {
				loadedModules.module = null;
				addView.dispatch(createInstance((selectedMenu.menuItem as MenuItemInternalModule).moduleName));
				
			} else if(selectedMenu.menuItem is MenuItemExternalModule) {
				//TODO: load external module				
			}

		}
		
		public function createInstance(className:String):Object
		{
			var myClass:Class = getDefinitionByName(className) as Class;
			var instance:Object = new myClass();
			return instance;
		}
	}
}