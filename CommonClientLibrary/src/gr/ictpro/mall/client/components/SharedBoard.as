package gr.ictpro.mall.client.components
{
	import flash.display.MovieClip;
	
	import org.osflash.signals.Signal;
	
	public class SharedBoard extends MovieClip
	{
		public var updateBoardSignal:Signal = new Signal();
		
		public function SharedBoard()
		{
			super();
		}
		
		protected final function updateBoard(obj:Object):void {
			updateBoardSignal.dispatch(obj);	
		}
		
		public function boardUpdated(obj:Object):void {
			// TODO: this needs to be overriden
		}
	}
}