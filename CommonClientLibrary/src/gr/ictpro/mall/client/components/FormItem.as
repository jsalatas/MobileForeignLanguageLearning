package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.FormItem;
	import spark.skins.spark.StackedFormItemSkin;
	
	public class FormItem extends spark.components.FormItem
	{
		public function FormItem()
		{
			super();
			super.setStyle("skinClass", Device.formItemSkin);
			super.setStyle("fontSize", Device.getScaledSize(super.getStyle("fontSize")));
			if(Device.isAndroid) {
				super.setStyle("textAlign", "left");
			} else {
				super.setStyle("textAlign", "right");
			}
			
		}
	}
}