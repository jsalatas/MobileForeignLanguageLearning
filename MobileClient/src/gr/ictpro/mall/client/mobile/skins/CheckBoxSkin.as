package gr.ictpro.mall.client.mobile.skins
{
	import flash.display.CapsStyle;
	import flash.display.GraphicsPathCommand;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import mx.core.DPIClassification;
	
	import spark.skins.mobile.CheckBoxSkin;
	
	import gr.ictpro.mall.client.components.Path;
	import gr.ictpro.mall.client.model.Device;


	public class CheckBoxSkin extends spark.skins.mobile.CheckBoxSkin
	{
		protected var lineWidth: Number;

		public function CheckBoxSkin()
		{
			super();
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					layoutGap = 10; //Device.getScaledSize(5);
					layoutPaddingLeft = 20; //Device.getScaledSize(10);
					layoutPaddingRight = 20; //Device.getScaledSize(10);
					layoutPaddingTop = 20; //Device.getScaledSize(10);
					layoutPaddingBottom = 20; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 64; //Device.getScaledSize(100);
					measuredDefaultHeight = 64; //Device.getScaledSize(22);
					minWidth= 64; //Device.getScaledSize(100);
					minHeight = 64; //Device.getScaledSize(22);
					lineWidth = 4;
					break;
				}
				case DPIClassification.DPI_240:
				{
					layoutGap = 8; //Device.getScaledSize(5);
					layoutPaddingLeft = 15; //Device.getScaledSize(10);
					layoutPaddingRight = 15; //Device.getScaledSize(10);
					layoutPaddingTop = 15; //Device.getScaledSize(10);
					layoutPaddingBottom = 15; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 48; //Device.getScaledSize(100);
					measuredDefaultHeight = 48; //Device.getScaledSize(22);
					minWidth= 48; //Device.getScaledSize(100);
					minHeight = 48; //Device.getScaledSize(22);			
					lineWidth = 2;
					break;
				}
				default:
				{
					// default PPI160
					layoutGap = 5; //Device.getScaledSize(5);
					layoutPaddingLeft = 10; //Device.getScaledSize(10);
					layoutPaddingRight = 10; //Device.getScaledSize(10);
					layoutPaddingTop = 10; //Device.getScaledSize(10);
					layoutPaddingBottom = 10; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 32; //Device.getScaledSize(100);
					measuredDefaultHeight = 32; //Device.getScaledSize(22);
					minWidth= 32; //Device.getScaledSize(100);
					minHeight = 32; //Device.getScaledSize(22);			
					lineWidth = 2;
					break;
				}
			}

		}
		
		override protected function measure():void
		{
			super.measure();
			measuredMinWidth = minWidth;
			measuredMinHeight = minHeight;
			
			measuredWidth = minWidth;
			measuredHeight = minHeight;

		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.lineStyle(lineWidth, Device.getDefaultColor(), 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			graphics.beginFill(0xFFFFFF, 0);
			
			graphics.drawRoundRect(layoutBorderSize + x, layoutBorderSize + y, 
				unscaledWidth - (layoutBorderSize * 2), 
				unscaledHeight - (layoutBorderSize * 2), 
				0, 0);
			
			graphics.endFill();
			
			if ((currentState == "upAndSelected")
				|| (currentState == "disabledAndSelected") 
			|| currentState == "downAndSelected") {
				graphics.lineStyle(lineWidth, Device.getDefaultColor(), 0, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
				graphics.beginFill(Device.getDefaultColor());
				var commands:Vector.<int> = new Vector.<int>(7, true);
				commands[0] = GraphicsPathCommand.MOVE_TO;
				commands[1] = GraphicsPathCommand.LINE_TO;
				commands[2] = GraphicsPathCommand.LINE_TO;
				commands[3] = GraphicsPathCommand.LINE_TO;
				commands[4] = GraphicsPathCommand.LINE_TO;
				commands[5] = GraphicsPathCommand.LINE_TO;
				commands[6] = GraphicsPathCommand.LINE_TO;

				var coords:Vector.<Number> = new Vector.<Number>(14, true);
				coords[0] = Device.getScaledSize(2);
				coords[1] = Device.getScaledSize(8);

				coords[2] = Device.getScaledSize(6);
				coords[3] = Device.getScaledSize(13);
				
				coords[4] = Device.getScaledSize(18);
				coords[5] = Device.getScaledSize(0);

				coords[6] = Device.getScaledSize(16);
				coords[7] = Device.getScaledSize(0);

				coords[8] = Device.getScaledSize(6);
				coords[9] = Device.getScaledSize(11);

				coords[10] = Device.getScaledSize(2);
				coords[11] = Device.getScaledSize(6);

				coords[12] = Device.getScaledSize(2);
				coords[13] = Device.getScaledSize(8);

				graphics.drawPath(commands, coords);
				graphics.endFill();

			}
		}
		
		override protected function commitCurrentState():void
		{   
			invalidateDisplayList();
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// do nothing
		}
		
	}
}