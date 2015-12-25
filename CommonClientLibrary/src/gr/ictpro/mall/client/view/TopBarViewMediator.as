package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import gr.ictpro.mall.client.components.TopBarView;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationHandledSignal;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class TopBarViewMediator extends Mediator
	{
		[Inject]
		public var view:TopBarView;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var serverNotificationHandle:ServerNotificationHandledSignal;

		private var _backHandler:Function;
		
		override public function onRegister():void
		{
			view.addEventListener("backClicked", backClicked);
		}
		

		protected function setBackHandler(backHandler:Function):void
		{
			this._backHandler = backHandler;
		}

		protected function back():void
		{
			if(_backHandler != null)
				_backHandler();
			
			view.removeEventListener("backClicked", backClicked);
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
			view.dispose();

		}
		
		protected function backClicked(event:MouseEvent):void
		{
			back();
		}

	}
}