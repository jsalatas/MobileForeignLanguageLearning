package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.InteractionMode;
	
	import spark.components.Button;
	
	public class Button extends spark.components.Button
	{
		public function Button()
		{
			super();
			super.setStyle("skinClass", Device.buttonSkin);
			
			if(Device.isAndroid) {
				super.setStyle("interactionMode", InteractionMode.TOUCH);
			} else {
				super.setStyle("interactionMode", InteractionMode.MOUSE);
			}

		}
	}
}