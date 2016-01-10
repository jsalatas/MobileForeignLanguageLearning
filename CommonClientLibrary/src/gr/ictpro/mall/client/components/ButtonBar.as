package gr.ictpro.mall.client.components
{
	import mx.core.InteractionMode;
	
	import spark.components.ButtonBar;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	public class ButtonBar extends spark.components.ButtonBar
	{
		public function ButtonBar()
		{
			super();
			super.setStyle("skinClass", Device.buttonBarSkin);
			super.setStyle("color", Device.getDefaultColor());
			super.setStyle("fontWeight", 'normal');
			super.setStyle("focusColor", Device.getDefaultColor(0.2));
			super.setStyle("fontSize", Device.getDefaultScaledFontSize());
			if(Device.isAndroid) {
				super.setStyle("interactionMode", InteractionMode.TOUCH);
			} else {
				super.setStyle("interactionMode", InteractionMode.MOUSE);
			}
		}
	}
}