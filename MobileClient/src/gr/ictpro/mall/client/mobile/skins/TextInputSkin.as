package gr.ictpro.mall.client.mobile.skins
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	import mx.core.DPIClassification;
	
	import spark.skins.mobile.TextInputSkin;
	
	public class TextInputSkin extends spark.skins.mobile.TextInputSkin
	{
		private var lineWidth:Number;
		public function TextInputSkin()
		{
			super();
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					layoutCornerEllipseSize = 24; //Device.getScaledSize(12);
					measuredDefaultWidth = 600; //Device.getScaledSize(300);
					measuredDefaultHeight = 66; //Device.getScaledSize(33);
					layoutBorderSize = 1;
					lineWidth = 4;
					break;
				}
				case DPIClassification.DPI_240:
				{
					layoutCornerEllipseSize = 18; //Device.getScaledSize(12);
					measuredDefaultWidth = 450; //Device.getScaledSize(300);
					measuredDefaultHeight = 50; //Device.getScaledSize(33);
					layoutBorderSize = 1;
					lineWidth = 2;
					break;
				}
				default:
				{
					// default PPI160
					layoutCornerEllipseSize = 12; //Device.getScaledSize(12);
					measuredDefaultWidth = 300; //Device.getScaledSize(300);
					measuredDefaultHeight = 33; //Device.getScaledSize(33);
					layoutBorderSize = 1;
					lineWidth = 2;
					break;
				}
			}

			super.setStyle("borderVisible", false);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		}

		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.lineStyle(lineWidth, Device.getDefaultColor(), 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			graphics.beginFill(Device.getDefaultColor(), 0.01);
			graphics.drawRoundRect(layoutBorderSize + x, layoutBorderSize + y, 
				unscaledWidth - (layoutBorderSize * 2), 
				unscaledHeight - (layoutBorderSize * 2), 
				layoutCornerEllipseSize, layoutCornerEllipseSize);
			

			graphics.endFill();
		}

	}
}