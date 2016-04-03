package gr.ictpro.mall.client.components
{
	import spark.layouts.TileLayout;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	public class TileLayout extends spark.layouts.TileLayout
	{
		public function TileLayout()
		{
			super();
		}
		
		override public function set horizontalGap(value:Number):void
		{
			super.horizontalGap = Device.getScaledSize(value);	
		}
		
		public function get definedHorizontalGap():Number
		{
			return Device.getUnScaledSize(super.horizontalGap);
		}
		
		override public function set verticalGap(value:Number):void
		{
			super.verticalGap = Device.getScaledSize(value);	
		}
		
		public function get definedVerticalGap():Number
		{
			return Device.getUnScaledSize(super.verticalGap);
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