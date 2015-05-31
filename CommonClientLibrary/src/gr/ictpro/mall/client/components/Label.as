package gr.ictpro.mall.client.components
{
	import flash.text.TextFormat;
	
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.Label;
	
	public class Label extends spark.components.Label
	{
		public function Label()
		{
			super();
			super.setStyle("fontSize", Device.getScaledSize(super.getStyle("fontSize")));
		}
	}
}