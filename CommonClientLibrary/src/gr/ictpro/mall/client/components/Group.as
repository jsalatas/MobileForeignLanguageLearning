package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.Group;
	
	public class Group extends spark.components.Group
	{
		public function Group()
		{
			super();
			super.setStyle("fontSize", Device.getScaledSize(super.getStyle("fontSize")));
		}
	}
}