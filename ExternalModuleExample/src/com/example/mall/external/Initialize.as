package com.example.mall.external
{
	import gr.ictpro.mall.client.components.Module;
	import gr.ictpro.mall.client.components.TopBarView;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	
	public class Initialize extends Module
	{
		public function Initialize()
		{
			super();
		}
		
		[Inject]
		public function set mediatorMap(mediatorMap:IMediatorMap):void {
			mediatorMap.mapView(ExampleView, ExampleViewMediator, TopBarView);
		}
		
		[Inject]
		public function set injector(injector:IInjector):void {
			var addonMenu:AddonMenu = new AddonMenu();
			injector.injectInto(addonMenu);
			addonMenu.registerAddonMenu();

		}

	}
}