package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.runtime.Device;
	
	import spark.components.supportClasses.Skin;
	
	public class Skin extends spark.components.supportClasses.Skin
	{
		public function Skin()
		{
			super();
			super.setStyle("fontSize", Device.getDefaultScaledFontSize());
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