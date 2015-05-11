package gr.ictpro.mall.client.controller
{
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.model.menu.MenuItem;
	import gr.ictpro.mall.client.model.menu.MenuItemCommand;
	import gr.ictpro.mall.client.model.menu.MenuItemExternalModule;
	import gr.ictpro.mall.client.model.menu.MenuItemInternalModule;
	import gr.ictpro.mall.client.model.menu.MenuItemSelected;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	import spark.modules.ModuleLoader;
	
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
				trace("Loading internal: " + selectedMenu.menuItem.text);
				loadedModules.module = null;
				addView.dispatch(MenuCommand.createInstance((selectedMenu.menuItem as MenuItemInternalModule).moduleName));
				
			} else if(selectedMenu.menuItem is MenuItemExternalModule) {
				trace("Loading external: " + selectedMenu.menuItem.text);
				
			}

		}
		
		public static function createInstance(className:String):Object
		{
			var myClass:Class = getDefinitionByName(className) as Class;
			var instance:Object = new myClass();
			return instance;
		}
	}
}