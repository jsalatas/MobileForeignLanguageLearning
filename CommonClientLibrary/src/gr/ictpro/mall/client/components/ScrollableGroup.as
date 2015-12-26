package gr.ictpro.mall.client.components
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	
	import spark.layouts.supportClasses.LayoutBase;

	use namespace mx_internal
	
	public class ScrollableGroup extends Group
	{
		private var mxmlContentGroup:Group = new Group(); 
		private var _scroller:Scroller = new Scroller();

		public function ScrollableGroup()
		{
			super();
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_scroller.percentWidth = 100;
			_scroller.percentHeight = 100;
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
		
		override public function set layout(value:LayoutBase):void
		{
			mxmlContentGroup.layout = layout;
		}
		
		override public function set mxmlContent(value:Array):void
		{
			mxmlContentGroup.mxmlContent = value;
			invalidateDisplayList();
		}
	}
}