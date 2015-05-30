package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.FormItem;
	
	public class FormItem extends spark.components.FormItem
	{
		public function FormItem()
		{
			super();
			super.setStyle("skinClass", Device.formItemSkin);
		}
	}
}