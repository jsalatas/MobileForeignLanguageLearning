package gr.ictpro.mall.client.authentication.proximity
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.components.menu.MenuItemCommand;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.signal.SaveErrorSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;

	public class AddonMenu
	{
		[Inject]
		public var saveSuccess:SaveSuccessSignal;

		[Inject]
		public var saveError:SaveErrorSignal;

		[Inject]
		public var saveSignal:SaveSignal;
		
		[Inject]
		public var mainMenu:MainMenu;
		
		public function AddonMenu()
		{
		}
	
		public function registerAddonMenu():void
		{
			mainMenu.registerMenuItem(new MenuItemCommand(Device.translations.getTranslation("Exit and forget me"), Icons.icon_logout, forgetAndTerminate));
		}
		
		private function forgetAndTerminate():void
		{
			saveSuccess.add(saveSuccessHandler);
			saveError.add(saveErrorHandler);
			var setting:ClientSetting = new ClientSetting();
			setting.name = "lastUserName";
			setting.value = null;
			saveSignal.dispatch(setting);
		}
		
		private function saveSuccessHandler(classType:Class):void
		{
			if(classType == ClientSetting) {
				terminate();
			}
		}
		
		private function saveErrorHandler(classType:Class, errorMessage:String):void
		{
			if(classType == ClientSetting) {
				terminate();
			}
		}
		
		private function removeHandlers():void
		{
			saveSuccess.remove(saveSuccessHandler);
			saveError.remove(saveErrorHandler);
		}
		
		private function terminate():void {
			removeHandlers();
			var exitingEvent:Event = new Event(Event.EXITING, false, true); 
			NativeApplication.nativeApplication.dispatchEvent(exitingEvent); 
			if (!exitingEvent.isDefaultPrevented()) { 
				NativeApplication.nativeApplication.exit(); 
			} 
		}
	}

}