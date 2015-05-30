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
	}
}