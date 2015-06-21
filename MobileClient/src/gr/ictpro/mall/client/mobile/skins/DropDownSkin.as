package gr.ictpro.mall.client.mobile.skins
{
	import flash.display.CapsStyle;
	import flash.display.GraphicsPathCommand;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.text.TextLineMetrics;
	
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	
	import spark.components.supportClasses.StyleableTextField;
	
	use namespace mx_internal;

	public class DropDownSkin extends ButtonSkin
	{
		protected var lineWidth: Number;

		public function DropDownSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					layoutGap = 10; //Device.getScaledSize(5);
					layoutCornerEllipseSize = 24;
					layoutPaddingLeft = 0; //Device.getScaledSize(10);
					layoutPaddingRight = 0; //Device.getScaledSize(10);
					layoutPaddingTop = 0; //Device.getScaledSize(10);
					layoutPaddingBottom = 0; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 200; //Device.getScaledSize(100);
					measuredDefaultHeight = 66; //Device.getScaledSize(22);
					minWidth= 200; //Device.getScaledSize(100);
					minHeight = 66; //Device.getScaledSize(22);
					iconDefaultHeight = 30;
					lineWidth = 4;
					dpiScale = 2;
					break;
				}
				case DPIClassification.DPI_240:
				{
					layoutGap = 8; //Device.getScaledSize(5);
					layoutCornerEllipseSize = 18;
					layoutPaddingLeft = 0; //Device.getScaledSize(10);
					layoutPaddingRight = 0; //Device.getScaledSize(10);
					layoutPaddingTop = 0; //Device.getScaledSize(10);
					layoutPaddingBottom = 0; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 150; //Device.getScaledSize(100);
					measuredDefaultHeight = 50; //Device.getScaledSize(22);
					minWidth= 150; //Device.getScaledSize(100);
					minHeight = 33; //Device.getScaledSize(22);			
					iconDefaultHeight = 30;
					iconDefaultHeight = 23;
					lineWidth = 2;
					dpiScale = 1.5;
					break;
				}
				default:
				{
					// default PPI160
					layoutGap = 5; //Device.getScaledSize(5);
					layoutCornerEllipseSize = 12;
					layoutPaddingLeft = 0; //Device.getScaledSize(10);
					layoutPaddingRight = 0; //Device.getScaledSize(10);
					layoutPaddingTop = 0; //Device.getScaledSize(10);
					layoutPaddingBottom = 0; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 100; //Device.getScaledSize(100);
					measuredDefaultHeight = 33; //Device.getScaledSize(22);
					minWidth= 100; //Device.getScaledSize(100);
					minHeight = 22; //Device.getScaledSize(22);			
					iconDefaultHeight = 15;
					lineWidth = 2;
					dpiScale = 1.5;
					break;
				}
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(labelDisplayShadow) {
				removeChild(labelDisplayShadow);
			}
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.lineStyle(lineWidth, Device.getDefaultColor(), 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			graphics.beginFill(Device.getDefaultColor(), 0.01);
			
			graphics.drawRoundRect(layoutBorderSize + x, layoutBorderSize + y, 
				unscaledWidth - (layoutBorderSize * 2) - Device.getScaledSize(22), 
				unscaledHeight - (layoutBorderSize * 2), 
				layoutCornerEllipseSize, layoutCornerEllipseSize);
			graphics.endFill();
			
			graphics.beginFill(Device.getDefaultColor());
				
			var commands:Vector.<int> = new Vector.<int>(4, true);
			commands[0] = GraphicsPathCommand.MOVE_TO;
			commands[1] = GraphicsPathCommand.LINE_TO;
			commands[2] = GraphicsPathCommand.LINE_TO;
			commands[3] = GraphicsPathCommand.LINE_TO;
			
			var baseX:int = unscaledWidth -Device.getScaledSize(19);
			var baseY:int = (unscaledHeight -Device.getScaledSize(8)) / 2;
			var coords:Vector.<Number> = new Vector.<Number>(8, true);
			coords[0] = baseX;
			coords[1] = baseY;
			coords[2] = baseX + Device.getScaledSize(8);
			coords[3] = baseY + Device.getScaledSize(8);
			coords[4] = baseX + Device.getScaledSize(16);
			coords[5] = baseY;
			coords[6] = baseX;
			coords[7] = baseY;
			
			
			graphics.drawPath(commands, coords);

			graphics.endFill();
		}

		override protected function measure():void
		{
			super.measure();
			
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			var textDescent:Number = 0;
			
			// reset text if it was truncated before.
			if (hostComponent && labelDisplay.isTruncated)
				labelDisplay.text = hostComponent.label;
			
			// we want to get the label's width and height if we have text or there's
			// no icon present
			if (labelDisplay.text != "")
			{
				labelWidth = getElementPreferredWidth(labelDisplay) * dpiScale;
				labelHeight = getElementPreferredHeight(labelDisplay) * dpiScale;
				textDescent = labelDisplay.getLineMetrics(0).descent;
			}
			
			var w:Number = layoutPaddingLeft + layoutPaddingRight;
			var h:Number = 0;
			
			var iconWidth:Number = 0;
			var iconHeight:Number = 0;
			
			// layoutPaddingBottom is from the bottom of the button to the text
			// baseline or the bottom of the icon.
			// It must be adjusted when descent grows larger than the padding.
			var adjustablePaddingBottom:Number = layoutPaddingBottom;
			
			w += labelWidth;
			h += labelHeight;
				
			adjustablePaddingBottom = layoutPaddingBottom;
				
			if (labelHeight)
			{
				adjustablePaddingBottom = Math.max(layoutPaddingBottom, textDescent);
					
				h += layoutGap;
			}
			
			h += layoutPaddingTop + adjustablePaddingBottom;
			
			// measuredMinHeight for width and height for a square measured minimum size
			measuredMinWidth = h;
			measuredMinHeight = h;
			
			measuredWidth = w
			measuredHeight = h;
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var hasLabel:Boolean = (hostComponent && hostComponent.label != "");
			
			var labelX:Number = 0;
			var labelY:Number = 0;
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			
			var textWidth:Number = 0;
			var textHeight:Number = 0;
			var textDescent:Number = 0;
			
			// vertical gap grows when text descent > gap
			var adjustableGap:Number = 0;
			
			// bottom constraint grows when text descent > layoutPaddingBottom
			var adjustablePaddingBottom:Number = layoutPaddingBottom;
			
			// reset text if it was truncated before.
			if (hostComponent && labelDisplay.isTruncated)
				labelDisplay.text = hostComponent.label;
			
			if (hasLabel)
			{
				var metrics:TextLineMetrics = labelDisplay.getLineMetrics(0);
				textWidth = getElementPreferredWidth(labelDisplay);
				textHeight = getElementPreferredHeight(labelDisplay);
				textDescent = metrics.descent;
			}
			
			var viewWidth:Number = Math.max(unscaledWidth - layoutPaddingLeft - layoutPaddingRight, 0);
			var viewHeight:Number = Math.max(unscaledHeight - layoutPaddingTop - adjustablePaddingBottom, 0);
			
			
			// snap label to left and right bounds
			labelWidth = viewWidth;
			
			// default label vertical positioning is ascent centered
			labelHeight = Math.min(viewHeight, textHeight);
			labelY = (viewHeight - labelHeight) / 2;
			
			// label width constrained by icon width
			labelWidth = Math.max(Math.min(viewWidth - adjustableGap, textWidth), 0);
				
			labelX = layoutGap;

			// adjust labelHeight for vertical clipping at the bottom edge
			if (labelHeight < textHeight)
			{
				// allow gutter to be outside skin bounds
				// this appears as clipping by the bottom border
				var labelViewHeight:Number = Math.min(unscaledHeight - layoutPaddingTop - labelY 
					- textDescent + (StyleableTextField.TEXT_HEIGHT_PADDING / 2), textHeight);
				labelHeight = Math.max(labelViewHeight, labelHeight);
			}
			
			labelX = Math.max(0, Math.round(labelX)) + layoutPaddingLeft;
			// text looks better a little high as opposed to low, so we use floor instead of round
			labelY = Math.max(0, Math.floor(labelY)) + layoutPaddingTop;
			
			setElementSize(labelDisplay, labelWidth, labelHeight);
			setElementPosition(labelDisplay, labelX , labelY );
			
			if (textWidth > labelWidth)
				labelDisplay.truncateToFit();
			
			layoutBorder(unscaledWidth, unscaledHeight);
			
			labelDisplay.setStyle("textAlign", "left");
			labelDisplay.commitStyles();
		}

		override mx_internal function layoutBorder(unscaledWidth:Number, unscaledHeight:Number):void
		{
		}
		

	}
}