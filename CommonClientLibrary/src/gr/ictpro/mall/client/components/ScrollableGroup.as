package gr.ictpro.mall.client.components
{
	import mx.core.mx_internal;
	
	import spark.layouts.supportClasses.LayoutBase;

	use namespace mx_internal
	
	public class ScrollableGroup extends Group
	{
		private var mxmlContentGroup:Group = new Group(); 
		
		public function ScrollableGroup()
		{
			super();
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			var scroller:Scroller = new Scroller();
			scroller.percentWidth = 100;
			scroller.percentHeight = 100;
			scroller.minViewportInset = 1;
			scroller.hasFocusableChildren = false;
			scroller.ensureElementIsVisibleForSoftKeyboard = false;
			scroller.viewport = mxmlContentGroup;
			scroller.viewport = mxmlContentGroup;
			addElement(scroller);
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