package gr.ictpro.mall.client.view
{
	import org.robotlegs.mvcs.Mediator;
	
	public class ProfileViewMediator extends Mediator
	{
		[Inject]
		public var view:ProfileView;
		
		override public function onRegister():void
		{
			//TODO: 
			trace("ProfileModule register");
		}
		
	}
}