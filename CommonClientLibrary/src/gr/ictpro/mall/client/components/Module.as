package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.modules.Module;
	
	public class Module extends spark.modules.Module
	{
		public function Module()
		{
			super();
			super.setStyle("skinClass", Device.skinnableContainerSkin);
		}
	}
}