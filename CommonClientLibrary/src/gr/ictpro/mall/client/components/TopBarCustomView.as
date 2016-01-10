package gr.ictpro.mall.client.components
{
	
	import mx.core.mx_internal;
	
	import spark.layouts.supportClasses.LayoutBase;

	use namespace mx_internal;	
	
	[Event(name="okClicked", type="flash.events.MouseEvent")]
	[Event(name="cancelClicked", type="flash.events.MouseEvent")]
	[Event(name="deleteClicked", type="flash.events.MouseEvent")]
	

	public class TopBarCustomView extends TopBarView
	{
		protected var mxmlContentGroup:Group; 
		public var _scroller:Scroller = new Scroller();

		public function TopBarCustomView()
		{
			super();
			mxmlContentGroup = new Group();
			
			deleteButton = false;
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
			addElement(_scroller);
			
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