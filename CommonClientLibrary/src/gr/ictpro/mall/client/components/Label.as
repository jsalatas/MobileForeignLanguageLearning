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
			//super.setStyle("fontSize", Device.getScaledSize(super.getStyle("fontSize")));
		}
		
		override public function setStyle(styleProp:String, newValue:*):void
		{
			if(styleProp == "fontSize") {
				newValue = Device.getScaledSize(newValue);
			}
			
			super.setStyle(styleProp, newValue);
		}

	}
}