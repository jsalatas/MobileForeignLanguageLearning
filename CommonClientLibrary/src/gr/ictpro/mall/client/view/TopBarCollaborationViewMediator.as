package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import gr.ictpro.mall.client.components.IParameterizedView;
	import gr.ictpro.mall.client.components.TopBarCollaborationView;
	import gr.ictpro.mall.client.components.TopBarView;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class TopBarCollaborationViewMediator extends SignalMediator
	{
		[Inject]
		public var view:TopBarCollaborationView;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var addView:AddViewSignal;

		public var cancelBack:Boolean = false;
		
		override public function onRegister():void
		{
			eventMap.mapListener(view, "backClicked", backClicked);
			eventMap.mapListener(view, "whiteboardClicked", whiteboardClicked);
			eventMap.mapListener(view, "videoClicked", videoClicked);
			eventMap.mapListener(view, "chatClicked", chatClicked);
			eventMap.mapListener(view, "settingsClicked", settingsClicked);
		}
		
		protected final function back():void
		{
			backHandler();

			if(cancelBack)
				return; 
			
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView, view.masterView is IParameterizedView?IParameterizedView(view.masterView).parameters:null);
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

		private function whiteboardClicked(event:MouseEvent):void
		{
			//TODO
		}

		private function videoClicked(event:MouseEvent):void
		{
			//TODO
		}

		private function chatClicked(event:MouseEvent):void
		{
			//TODO
		}

		private function settingsClicked(event:MouseEvent):void
		{
			//TODO
		}

	}
}