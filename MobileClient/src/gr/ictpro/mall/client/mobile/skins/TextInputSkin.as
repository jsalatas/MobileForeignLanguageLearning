package gr.ictpro.mall.client.mobile.skins
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.supportClasses.StyleableStageText;
	import spark.skins.mobile.StageTextInputSkin;
	
	public class TextInputSkin extends spark.skins.mobile.StageTextInputSkin
	{
		public function TextInputSkin()
		{
			super();
			borderClass = null; 
			layoutCornerEllipseSize = Device.getScaledSize(12);
			measuredDefaultWidth = Device.getScaledSize(300);
			measuredDefaultHeight = Device.getScaledSize(33);
			layoutBorderSize = 1;
			super.setStyle("borderVisible", false);
		}
		
		override protected function createChildren():void
		{
			if (!textDisplay)
			{
				textDisplay = new StyleableStageText(multiline);
				textDisplay.editable = true;
				
				textDisplay.styleName = this;
				this.addChild(textDisplay);
			}
		}

		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.lineStyle(Device.getScaledSize(2), Device.defaultColor, 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			graphics.beginFill(Device.defaultColor, 0.01);
			graphics.drawRoundRect(layoutBorderSize + x, layoutBorderSize + y, 
				unscaledWidth - (layoutBorderSize * 2), 
				unscaledHeight - (layoutBorderSize * 2), 
				layoutCornerEllipseSize, layoutCornerEllipseSize);
			

			graphics.endFill();
		}

	}
}