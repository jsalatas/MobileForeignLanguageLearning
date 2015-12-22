package gr.ictpro.mall.client.components
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.core.IVisualElement;
	import mx.core.mx_internal;

	use namespace mx_internal;	

	[Event(name="okClicked", type="flash.events.MouseEvent")]
	[Event(name="cancelClicked", type="flash.events.MouseEvent")]
	[Event(name="deleteClicked", type="flash.events.MouseEvent")]

	public class TopBarDetailView extends TopBarView 
	{
		private var _scroller:Scroller = new Scroller();

		public function TopBarDetailView()
		{
			super();
			deleteButton = true;
			cancelButton = true;
			okButton = true;
			addButton = false;
		}
	
		override protected function createChildren():void
		{
			super.createChildren();
			
			_scroller.percentWidth = 100;
			_scroller.percentHeight = 100;
			_scroller.minViewportInset = 1;
			_scroller.hasFocusableChildren = true;
			_scroller.ensureElementIsVisibleForSoftKeyboard = true;
			_scroller.viewport = mxmlContentGroup;
			mxmlContentGroup.addEventListener(FocusEvent.FOCUS_IN, globalFocusInHandler);
			mxmlContentGroup.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addElement(_scroller);
		}
		
		private function removedFromStageHandler(event:Event):void 
		{
			mxmlContentGroup.removeEventListener(FocusEvent.FOCUS_IN, globalFocusInHandler);
		}
		
		private function globalFocusInHandler(event:FocusEvent):void 
		{
			_scroller.ensureElementIsVisible(IVisualElement(event.target));
		}
		

	}
}