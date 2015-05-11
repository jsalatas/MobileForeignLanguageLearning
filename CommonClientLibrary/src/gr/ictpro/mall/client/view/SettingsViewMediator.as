package gr.ictpro.mall.client.view
{
	import org.robotlegs.mvcs.Mediator;
	
	public class SettingsViewMediator extends Mediator
	{
		[Inject]
		public var view:SettingsView;
		
		override public function onRegister():void
		{
			//TODO: 
			trace("SettingsModule register");
		}
		
	}
}