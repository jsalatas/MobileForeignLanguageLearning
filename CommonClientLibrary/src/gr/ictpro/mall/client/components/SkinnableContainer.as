package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.SkinnableContainer;
	
	public class SkinnableContainer extends spark.components.SkinnableContainer
	{
		public function SkinnableContainer()
		{
			super();
		}
		
		override public function set height(value:Number):void
		{
			super.height = Device.getScaledSize(value);
		}
		
		override public function set width(value:Number):void
		{
			super.width = Device.getScaledSize(value);
		}
	}
}