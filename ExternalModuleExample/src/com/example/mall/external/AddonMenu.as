package com.example.mall.external
{
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.components.menu.MenuItemInternalModule;
	import gr.ictpro.mall.client.runtime.Device;

	public class AddonMenu
	{
		[Inject]
		public var mainMenu:MainMenu;
		
		public function AddonMenu()
		{
		}
		
		public function registerAddonMenu():void
		{
			mainMenu.registerMenuItem(new MenuItemInternalModule(Device.translations.getTranslation("Example"), Icons.icon_example, ExampleView));
		}

	}
}