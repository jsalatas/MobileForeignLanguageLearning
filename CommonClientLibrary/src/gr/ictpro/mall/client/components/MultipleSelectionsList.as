package gr.ictpro.mall.client.components
{
	import flash.events.MouseEvent;

	public class MultipleSelectionsList extends List
	{
		public function MultipleSelectionsList()
		{
			super();
			allowMultipleSelection = true;
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void {
			event.ctrlKey = true;
			super.item_mouseDownHandler(event);
		}
	}
}