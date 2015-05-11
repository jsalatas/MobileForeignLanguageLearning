package gr.ictpro.mall.client.modules
{
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	public class ProfileModuleMediator extends ModuleMediator
	{
		[Inject]
		public var view:ProfileModule;
		
		override public function onRegister():void
		{
			//TODO: 
			trace("ProfileModule register");
		}
		
	}
}