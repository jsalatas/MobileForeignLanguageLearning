package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.InteractionMode;
	
	import spark.components.List;
	
	public class List extends spark.components.List
	{
		public function List()
		{
			super();
			super.setStyle("skinClass", Device.listSkin);
			if(Device.isAndroid) {
				super.setStyle("interactionMode", InteractionMode.TOUCH);
			} else {
				super.setStyle("interactionMode", InteractionMode.MOUSE);
			}

		}
		
		override public function set height(value:Number):void
		{
			super.height = Device.getScaledSize(value);
		}
		
		override public function set width(value:Number):void
		{
			super.width = Device.getScaledSize(value);
		}

	}
}