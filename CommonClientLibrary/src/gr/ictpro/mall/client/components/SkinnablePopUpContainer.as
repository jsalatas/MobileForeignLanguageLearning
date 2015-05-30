package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.SkinnablePopUpContainer;
	
	public class SkinnablePopUpContainer extends spark.components.SkinnablePopUpContainer
	{
		public function SkinnablePopUpContainer()
		{
			super();
			super.setStyle("skinClass", Device.skinnablePopUpContainerSkin);
		}
	}
}