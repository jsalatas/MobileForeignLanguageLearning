package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.InteractionMode;
	
	import spark.layouts.supportClasses.LayoutBase;
	import spark.modules.Module;
	
	public class Module extends spark.modules.Module
	{
		private var mxmlContentGroup:Group = new Group(); 
		public function Module()
		{
			super();
			super.setStyle("skinClass", Device.skinnableContainerSkin);
			
			if(Device.isAndroid) {
				super.setStyle("interactionMode", InteractionMode.TOUCH);
			} else {
				super.setStyle("interactionMode", InteractionMode.MOUSE);
			}	
			

		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var scroller:Scroller = new Scroller();
			scroller.percentWidth = 100;
			scroller.percentHeight = 100;
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