package gr.ictpro.mall.client.mobile.skins
{
	import flash.display.CapsStyle;
	import flash.display.GraphicsPathCommand;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	
	import gr.ictpro.mall.client.components.ColoredButton;
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.DPIClassification;
	

	public class ColorDropDownSkin extends DropDownSkin
	{
		public function ColorDropDownSkin()
		{
			super();
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.lineStyle(lineWidth, Device.getDefaultColor(), 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			graphics.beginFill((hostComponent as ColoredButton).bgColor);
			
			graphics.drawRoundRect(layoutBorderSize + x, layoutBorderSize + y, 
				unscaledWidth - (layoutBorderSize * 2) - Device.getScaledSize(16), 
				unscaledHeight - (layoutBorderSize * 2), 
				layoutCornerEllipseSize, layoutCornerEllipseSize);
			graphics.endFill();
			
			graphics.beginFill(Device.getDefaultColor());
			
			var commands:Vector.<int> = new Vector.<int>(4, true);
			commands[0] = GraphicsPathCommand.MOVE_TO;
			commands[1] = GraphicsPathCommand.LINE_TO;
			commands[2] = GraphicsPathCommand.LINE_TO;
			commands[3] = GraphicsPathCommand.LINE_TO;
			
			var baseX:int = unscaledWidth -Device.getScaledSize(10);
			var baseY:int = (unscaledHeight -Device.getScaledSize(5)) / 2;
			var coords:Vector.<Number> = new Vector.<Number>(8, true);
			coords[0] = baseX;
			coords[1] = baseY;
			coords[2] = baseX + Device.getScaledSize(5);
			coords[3] = baseY + Device.getScaledSize(5);
			coords[4] = baseX + Device.getScaledSize(10);
			coords[5] = baseY;
			coords[6] = baseX;
			coords[7] = baseY;
			
			
			graphics.drawPath(commands, coords);
			
			graphics.endFill();
		}

	}
}