package gr.ictpro.mall.client.modules
{
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	public class SettingsModuleMediator extends ModuleMediator
	{
		[Inject]
		public var view:SettingsModule;
		
		override public function onRegister():void
		{
			//TODO: 
			trace("SettingsModule register");
		}
		
	}
}