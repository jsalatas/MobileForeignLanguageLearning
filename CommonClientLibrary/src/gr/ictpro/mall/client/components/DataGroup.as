package gr.ictpro.mall.client.components
{
	import mx.core.InteractionMode;
	
	import spark.components.DataGroup;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	public class DataGroup extends spark.components.DataGroup
	{
		public function DataGroup()
		{
			super();
			if(Device.isAndroid) {
				super.setStyle("interactionMode", InteractionMode.TOUCH);
			} else {
				super.setStyle("interactionMode", InteractionMode.MOUSE);
			}
		}
	}
}