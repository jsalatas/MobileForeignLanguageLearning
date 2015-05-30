package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.TextInput;
	
	public class TextInput extends spark.components.TextInput
	{
		public function TextInput()
		{
			super();
			super.setStyle("skinClass", Device.textInputSkin);
		}
	}
}