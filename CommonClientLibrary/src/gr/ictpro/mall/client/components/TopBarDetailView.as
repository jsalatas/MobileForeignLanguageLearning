package gr.ictpro.mall.client.components
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.core.mx_internal;
	import mx.managers.FocusManager;

	use namespace mx_internal;	

	[Event(name="okClicked", type="flash.events.MouseEvent")]
	[Event(name="cancelClicked", type="flash.events.MouseEvent")]
	[Event(name="deleteClicked", type="flash.events.MouseEvent")]

	public class TopBarDetailView extends TopBarView  
	{
		
		public var _scroller:Scroller = new Scroller();
		private var fm:FocusManager;
		public function TopBarDetailView()
		{
			super();
			deleteButton = true;
			cancelButton = true;
			okButton = true;
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
			mxmlContentGroup.getVerticalScrollPositionDelta(1);
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
			//_scroller.ensureElementIsVisible(IVisualElement(event.target));
		}
	}
}