package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.supportClasses.Skin;
	
	public class Skin extends spark.components.supportClasses.Skin
	{
		public function Skin()
		{
			super();
			super.setStyle("fontSize", Device.getDefaultScaledFontSize() * (Device.isAndroid?2:1));
		}
		
		override public function setStyle(styleProp:String, newValue:*):void
		{
			if(styleProp == "fontSize") {
				newValue = Device.getScaledSize(newValue) * (Device.isAndroid?2:1);
			}
			super.setStyle(styleProp, newValue);
		}

	}
}