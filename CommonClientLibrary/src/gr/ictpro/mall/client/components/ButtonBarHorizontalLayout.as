package gr.ictpro.mall.client.components
{
	import spark.components.supportClasses.ButtonBarHorizontalLayout;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	public class ButtonBarHorizontalLayout extends spark.components.supportClasses.ButtonBarHorizontalLayout
	{
		public function ButtonBarHorizontalLayout()
		{
			super();
		}

		override public function set gap(value:int):void
		{
			super.gap = Device.getScaledSize(value);	
		}
		
		public function get definedGap():int
		{
			return Device.getUnScaledSize(super.gap);
		}
		
	}
}