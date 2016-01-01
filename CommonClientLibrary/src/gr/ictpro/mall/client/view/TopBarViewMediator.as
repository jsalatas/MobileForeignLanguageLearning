package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import gr.ictpro.mall.client.components.TopBarView;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class TopBarViewMediator extends SignalMediator
	{
		[Inject]
		public var view:TopBarView;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var addView:AddViewSignal;

		public var cancelBack:Boolean = false;
		
		override public function onRegister():void
		{
			eventMap.mapListener(view, "backClicked", backClicked);
		}
		
		protected final function back():void
		{
			backHandler();

			if(cancelBack)
				return; 
			
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
			view.dispose();

		}
		
		protected function backHandler():void
		{
			
		}

		private function backClicked(event:MouseEvent):void
		{
			back();
		}

	}
}