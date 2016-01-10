package gr.ictpro.mall.client.mobile.skins
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	public class ButtonBarButtonSkin extends ButtonSkin
	{
		public function ButtonBarButtonSkin()
		{
			super();
			useCenterAlignment = false;			

		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var isSelected:Boolean = currentState.indexOf("Selected") >= 0;
			
			graphics.lineStyle(lineWidthUp, Device.getDefaultColor(), currentState=="disabled"?0.5:1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			graphics.beginFill(isSelected?0xffffff:Device.getDefaultColor(), isSelected?1.0:(currentState=="disabled"?0.5:0.1));
			
			graphics.drawRoundRect(layoutBorderSize + x, layoutBorderSize + y, 
				unscaledWidth - (layoutBorderSize * 2), 
				unscaledHeight - (layoutBorderSize * 2), 
				layoutCornerEllipseSize, layoutCornerEllipseSize);
			
			graphics.endFill();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay.left= Device.getScaledSize(5); 
			labelDisplay.right=Device.getScaledSize(15);
		}
		

	}
}