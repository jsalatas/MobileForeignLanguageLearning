package gr.ictpro.mall.client.potato {
	import org.robotlegs.mvcs.SignalMediator;
	
	public class PotatoBoardMediator extends SignalMediator {

		override public function onRegister():void
		{
			super.onRegister();
			trace("@@@@@  Potato Mediator created");
		}

	}
	
}
