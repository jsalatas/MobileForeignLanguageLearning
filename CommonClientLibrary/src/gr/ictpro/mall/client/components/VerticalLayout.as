package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.layouts.VerticalLayout;
	
	public class VerticalLayout extends spark.layouts.VerticalLayout
	{
		public function VerticalLayout()
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
		
		override public function set paddingLeft(value:Number):void
		{
			super.paddingLeft = Device.getScaledSize(value);	
		}
		
		public function get definedPaddingLeft():Number
		{
			return Device.getUnScaledSize(super.paddingLeft);
		}
		
		override public function set paddingTop(value:Number):void
		{
			super.paddingTop = Device.getScaledSize(value);	
		}
		
		public function get definedPaddingTop():Number
		{
			return Device.getUnScaledSize(super.paddingTop);
		}
		
		override public function set paddingBottom(value:Number):void
		{
			super.paddingBottom = Device.getScaledSize(value);	
		}
		
		public function get definedPaddingBottom():Number
		{
			return Device.getUnScaledSize(super.paddingBottom);
		}
		
		override public function set paddingRight(value:Number):void
		{
			super.paddingRight = Device.getScaledSize(value);	
		}
		
		public function get definedPaddingRight():Number
		{
			return Device.getUnScaledSize(super.paddingRight);
		}
	}
}