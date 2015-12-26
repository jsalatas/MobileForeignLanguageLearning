package gr.ictpro.mall.client.mobile.skins
{
	import mx.core.ClassFactory;
	import mx.core.mx_internal;
	
	import spark.components.DataGroup;
	import spark.layouts.HorizontalAlign;
	import spark.skins.mobile.ListSkin;
	
	import gr.ictpro.mall.client.components.Scroller;
	import gr.ictpro.mall.client.components.VerticalLayout;
	
	use namespace mx_internal;
	
	public class ListSkin extends spark.skins.mobile.ListSkin
	{
		public function ListSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			if (!dataGroup)
			{
				// Create data group layout
				var layout:VerticalLayout = new VerticalLayout();
				layout.requestedMinRowCount = 5;
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
				layout.gap = 0;
				
				// Create data group
				dataGroup = new DataGroup();
				dataGroup.layout = layout;
				dataGroup.itemRenderer = new ClassFactory(spark.components.LabelItemRenderer);
			}
			if (!scroller)
			{
				// Create scroller
				scroller = new Scroller();
				scroller.minViewportInset = 1;
				scroller.hasFocusableChildren = false;
				scroller.ensureElementIsVisibleForSoftKeyboard = false;
				addChild(scroller);
			}
			
			// Associate scroller with data group
			if (!scroller.viewport)
			{
				scroller.viewport = dataGroup;
			}
		}
	}
}