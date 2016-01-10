package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;

	public class TopBarCustomViewMediator extends TopBarViewMediator
	{
		override public function onRegister():void
		{
			super.onRegister();

			eventMap.mapListener(view, "okClicked", okClicked);
			eventMap.mapListener(view, "cancelClicked", cancelClicked);

		}
		
		private function okClicked(event:MouseEvent):void
		{
			okHandler();
		}

		protected function okHandler():void {
			
		}

		private function cancelClicked(event:MouseEvent):void
		{
			cancelHandler();
		}
		
		protected function cancelHandler():void {
			
		}

	}
}