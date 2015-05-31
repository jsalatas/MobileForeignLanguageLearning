package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.Image;
	
	public class Image extends spark.components.Image
	{
		public function Image()
		{
			super();
			super.setStyle("skinClass", Device.imageSkin);
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