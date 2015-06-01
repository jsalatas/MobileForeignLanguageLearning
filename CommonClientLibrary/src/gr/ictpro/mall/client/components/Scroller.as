package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.components.skins.ScrollerSkin;
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.InteractionMode;
	
	import spark.components.Scroller;
	
	public class Scroller extends spark.components.Scroller
	{
		public function Scroller()
		{
			super();
			super.setStyle("skinClass", ScrollerSkin);
			if(Device.isAndroid) {
				super.setStyle("interactionMode", InteractionMode.TOUCH);
			} else {
				super.setStyle("interactionMode", InteractionMode.MOUSE);
			}
		}
	}
}