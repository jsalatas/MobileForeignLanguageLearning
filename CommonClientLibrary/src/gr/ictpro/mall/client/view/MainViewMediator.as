package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.User;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;
		
		override public function onRegister():void
		{
			view.showMenuClickled.add(handleShowMenu);			
		}
		
		private function handleShowMenu():void
		{
		}
		
		
	}
}