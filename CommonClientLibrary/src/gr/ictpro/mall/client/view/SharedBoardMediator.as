package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.components.SharedBoard;
	
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class SharedBoardMediator extends SignalMediator
	{
		[Inject]
		public var userSession: UserSession;

		[Inject]
		public var view:SharedBoard; 
		
		override public function onRegister():void
		{
			super.onRegister();
			trace(userSession.mainConnection.uri);
			addToSignal(view.updateBoardSignal, updateBoard);
		}
		
		private function updateBoard(obj:Object):void {
			view.boardUpdated(obj);
		}
	}
}