package com.example.mall.external
{
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.utils.ui.UI;
	import gr.ictpro.mall.client.view.TopBarCustomViewMediator;
	
	public class ExampleViewMediator extends TopBarCustomViewMediator
	{
		override public function onRegister():void
		{
			super.onRegister();
			
			addToSignal(ExampleView(view).helloClicked, sayHello);
		}
		
		
		private function sayHello():void
		{
			UI.showInfo(Device.translations.getTranslation("Hello World!"));
		}
		
	}
}