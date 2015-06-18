package gr.ictpro.mall.client.mobile.skins
{
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.text.TextLineMetrics;
	
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	
	import spark.components.IconPlacement;
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.ButtonSkin;
	
	use namespace mx_internal;
	
	public class ButtonSkin extends spark.skins.mobile.ButtonSkin
	{
		private var borderClass:Class;
		private var iconDefaultHeight: Number;
		private var lineWidthUp: Number;
		private var lineWidthDown: Number;
		private var dpiScale: Number;
		
		public function ButtonSkin()
		{
			super();
			
			upBorderSkin = null;
			downBorderSkin = null;
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					layoutGap = 10; //Device.getScaledSize(5);
					layoutCornerEllipseSize = 0;
					layoutPaddingLeft = 20; //Device.getScaledSize(10);
					layoutPaddingRight = 20; //Device.getScaledSize(10);
					layoutPaddingTop = 20; //Device.getScaledSize(10);
					layoutPaddingBottom = 20; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 200; //Device.getScaledSize(100);
					measuredDefaultHeight = 44; //Device.getScaledSize(22);
					minWidth= 200; //Device.getScaledSize(100);
					minHeight = 44; //Device.getScaledSize(22);
					iconDefaultHeight = 30;
					lineWidthUp = 2;
					lineWidthDown = 4;
					dpiScale = 2;
					break;
				}
				case DPIClassification.DPI_240:
				{
					layoutGap = 8; //Device.getScaledSize(5);
					layoutCornerEllipseSize = 0;
					layoutPaddingLeft = 15; //Device.getScaledSize(10);
					layoutPaddingRight = 15; //Device.getScaledSize(10);
					layoutPaddingTop = 15; //Device.getScaledSize(10);
					layoutPaddingBottom = 15; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 150; //Device.getScaledSize(100);
					measuredDefaultHeight = 33; //Device.getScaledSize(22);
					minWidth= 150; //Device.getScaledSize(100);
					minHeight = 33; //Device.getScaledSize(22);			
					iconDefaultHeight = 30;
					iconDefaultHeight = 23;
					lineWidthUp = 2;
					lineWidthDown = 3;
					dpiScale = 1.5;
					break;
				}
				default:
				{
					// default PPI160
					layoutGap = 5; //Device.getScaledSize(5);
					layoutCornerEllipseSize = 0;
					layoutPaddingLeft = 10; //Device.getScaledSize(10);
					layoutPaddingRight = 10; //Device.getScaledSize(10);
					layoutPaddingTop = 10; //Device.getScaledSize(10);
					layoutPaddingBottom = 10; //Device.getScaledSize(10);
					layoutBorderSize = 1;
					measuredDefaultWidth = 100; //Device.getScaledSize(100);
					measuredDefaultHeight = 22; //Device.getScaledSize(22);
					minWidth= 100; //Device.getScaledSize(100);
					minHeight = 22; //Device.getScaledSize(22);			
					iconDefaultHeight = 15;
					lineWidthUp = 1;
					lineWidthDown = 2;
					dpiScale = 1.5;
					break;
				}
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			var textDescent:Number = 0;
			var iconDisplay:DisplayObject = getIconDisplay();
			
			// reset text if it was truncated before.
			if (hostComponent && labelDisplay.isTruncated)
				labelDisplay.text = hostComponent.label;
			
			// we want to get the label's width and height if we have text or there's
			// no icon present
			if (labelDisplay.text != "" || !iconDisplay)
			{
				labelWidth = getElementPreferredWidth(labelDisplay) * dpiScale;
				labelHeight = getElementPreferredHeight(labelDisplay) * dpiScale;
				textDescent = labelDisplay.getLineMetrics(0).descent;
			}
			
			var w:Number = layoutPaddingLeft + layoutPaddingRight;
			var h:Number = 0;
			
			var iconWidth:Number = 0;
			var iconHeight:Number = 0;
			
			if (iconDisplay)
			{
				iconWidth = getElementPreferredWidth(iconDisplay) * dpiScale;
				iconHeight = getElementPreferredHeight(iconDisplay) * dpiScale;
				if(iconHeight> labelHeight) {
					iconWidth = iconWidth*(labelHeight+iconDefaultHeight)/iconHeight;
					iconHeight = labelHeight + iconDefaultHeight;
				}
			}
			
			var iconPlacement:String = getStyle("iconPlacement");
			
			// layoutPaddingBottom is from the bottom of the button to the text
			// baseline or the bottom of the icon.
			// It must be adjusted when descent grows larger than the padding.
			var adjustablePaddingBottom:Number = layoutPaddingBottom;
			
			if (iconPlacement == IconPlacement.LEFT ||
				iconPlacement == IconPlacement.RIGHT)
			{
				w += labelWidth + iconWidth;
				if (labelWidth && iconWidth)
					w += layoutGap;
				
				var viewHeight:Number = Math.max(labelHeight, iconHeight);
				h += viewHeight;
			}
			else
			{
				w += Math.max(labelWidth, iconWidth);
				h += labelHeight + iconHeight;
				
				adjustablePaddingBottom = layoutPaddingBottom;
				
				if (labelHeight && iconHeight)
				{
					if (iconPlacement == IconPlacement.BOTTOM)
					{
						// adjust gap if descent is larger
						h += Math.max(textDescent, layoutGap);
					}
					else
					{
						adjustablePaddingBottom = Math.max(layoutPaddingBottom, textDescent);
						
						h += layoutGap;
					}
				}
			}
			
			h += layoutPaddingTop + adjustablePaddingBottom;
			
			// measuredMinHeight for width and height for a square measured minimum size
			measuredMinWidth = h;
			measuredMinHeight = h;
			
			measuredWidth = w
			measuredHeight = h;
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.lineStyle(currentState=="up"?lineWidthUp:lineWidthDown, Device.getDefaultColor(), 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			graphics.beginFill(Device.getDefaultColor(), currentState == "up"?0.03:0.07);
			
			graphics.drawRoundRect(layoutBorderSize + x, layoutBorderSize + y, 
				unscaledWidth - (layoutBorderSize * 2), 
				unscaledHeight - (layoutBorderSize * 2), 
				layoutCornerEllipseSize, layoutCornerEllipseSize);
			
			graphics.endFill();
		}
		
		
		override protected function commitCurrentState():void
		{   
			invalidateDisplayList();
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
			
			var iconPlacement:String = getStyle("iconPlacement");
			var isHorizontal:Boolean = (iconPlacement == IconPlacement.LEFT || iconPlacement == IconPlacement.RIGHT);
			
			var iconX:Number = 0;
			var iconY:Number = 0;
			var unscaledIconWidth:Number = 0;
			var unscaledIconHeight:Number = 0;
			
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
			
			var iconDisplay:DisplayObject = getIconDisplay();
			
			if (iconDisplay)
			{
				unscaledIconWidth = getElementPreferredWidth(iconDisplay);
				unscaledIconHeight = getElementPreferredHeight(iconDisplay);
				adjustableGap = (hasLabel) ? layoutGap : 0;
			}
			
			// compute padding bottom based on descent and text position
			if (iconPlacement == IconPlacement.BOTTOM)
			{
				// icon bottom constrained by padding
				adjustablePaddingBottom = layoutPaddingBottom;
			}
			else if (iconPlacement == IconPlacement.TOP)
			{
				// adjust padding if descent is larger
				adjustablePaddingBottom = Math.max(layoutPaddingBottom, textDescent);
			}
			
			var viewWidth:Number = Math.max(unscaledWidth - layoutPaddingLeft - layoutPaddingRight, 0);
			var viewHeight:Number = Math.max(unscaledHeight - layoutPaddingTop - adjustablePaddingBottom, 0);
			
			
			var iconViewWidth:Number = Math.min(unscaledIconWidth, viewWidth);
			var iconViewHeight:Number = Math.min(unscaledIconHeight, viewHeight);
			
			if(iconDisplay) {
				iconViewWidth = iconViewHeight/iconDisplay.height==1?iconDisplay.width:iconViewWidth *iconViewHeight/iconDisplay.height;
			}
			
			// snap label to left and right bounds
			labelWidth = viewWidth;
			
			// default label vertical positioning is ascent centered
			labelHeight = Math.min(viewHeight, textHeight);
			labelY = (viewHeight - labelHeight) / 2;
			
			if (isHorizontal)
			{
				// label width constrained by icon width
				labelWidth = Math.max(Math.min(viewWidth - iconViewWidth - adjustableGap, textWidth), 0);
				
				if (useCenterAlignment)
					labelX = (viewWidth - labelWidth - iconViewWidth - adjustableGap) / 2;
				else
					labelX = 0;
				
				if (iconPlacement == IconPlacement.LEFT)
				{
					//iconX = 10;
					iconX = labelX;
					labelX += iconViewWidth + adjustableGap;
				}
				else
				{
					iconX  = labelX + labelWidth + adjustableGap;
				}
				
				iconY = (viewHeight - iconViewHeight) / 2;
			}
			else if (iconViewHeight)
			{
				// icon takes precedence over label
				labelHeight = Math.min(Math.max(viewHeight - iconViewHeight - adjustableGap, 0), textHeight);
				
				// adjust gap for descent when text is above icon
				if (hasLabel && (iconPlacement == IconPlacement.BOTTOM))
					adjustableGap = Math.max(adjustableGap, textDescent);
				
				if (useCenterAlignment)
				{
					// labelWidth already set to viewWidth with textAlign=center
					labelX = 0;
					
					// y-position for vertical center of both icon and label
					labelY = (viewHeight - labelHeight - iconViewHeight - adjustableGap) / 2;
				}
				else
				{
					// label horizontal center with textAlign=left
					labelWidth = Math.min(textWidth, viewWidth);
					labelX = (viewWidth - labelWidth) / 2;
				}
				
				// horizontally center iconWidth
				iconX = (viewWidth - iconViewWidth) / 2;
				
				var availableIconHeight:Number = viewHeight - labelHeight - adjustableGap;
				
				if (iconPlacement == IconPlacement.TOP)
				{
					if (useCenterAlignment)
					{
						iconY = labelY;
						labelY = iconY + adjustableGap + iconViewHeight;
					}
					else
					{
						if (unscaledIconHeight >= availableIconHeight)
						{
							// constraint to top
							iconY = 0;
						}
						else
						{
							// center icon in available height (above label) including gap
							// remove padding top since we offset again later
							iconY = ((availableIconHeight + layoutPaddingTop + adjustableGap - unscaledIconHeight) / 2) - layoutPaddingTop;
						}
						
						labelY = viewHeight - labelHeight;
					}
				}
				else // IconPlacement.BOTTOM
				{
					if (useCenterAlignment)
					{
						iconY = labelY + labelHeight + adjustableGap;
					}
					else
					{
						if (unscaledIconHeight >= availableIconHeight)
						{
							// constraint to bottom
							iconY = viewHeight - iconViewHeight;
						}
						else
						{
							// center icon in available height (below label) including gap
							iconY = ((availableIconHeight + adjustablePaddingBottom + adjustableGap - unscaledIconHeight) / 2) + labelHeight;
						}
						
						labelY = 0;
					}
				}
			}
			
			// adjust labelHeight for vertical clipping at the bottom edge
			if (isHorizontal && (labelHeight < textHeight))
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
			
			iconX = Math.max(0, Math.round(iconX)) + layoutPaddingLeft;
			iconY = Math.max(0, Math.round(iconY)) + layoutPaddingTop;
			
			setElementSize(labelDisplay, labelWidth, labelHeight);
			setElementPosition(labelDisplay, labelX , labelY );
			
			if (textWidth > labelWidth)
				labelDisplay.truncateToFit();
			
			if (iconDisplay)
			{
				// scale icon based on height
				setElementSize(iconDisplay, iconViewWidth, iconViewHeight);
				setElementPosition(iconDisplay, iconX, iconY);
			}
			
			layoutBorder(unscaledWidth, unscaledHeight);
			
			// update label shadow
			labelDisplayShadow.alpha = getStyle("textShadowAlpha");
			labelDisplayShadow.commitStyles();
			
			// don't use tightText positioning on shadow
			setElementPosition(labelDisplayShadow, labelDisplay.x, labelDisplay.y + 1);
			setElementSize(labelDisplayShadow, labelDisplay.width, labelDisplay.height);
			
			// if labelDisplay is truncated, then push it down here as well.
			// otherwise, it would have gotten pushed in the labelDisplay_valueCommitHandler()
			if (labelDisplay.isTruncated)
				labelDisplayShadow.text = labelDisplay.text;
			
			
		}
		
		override mx_internal function layoutBorder(unscaledWidth:Number, unscaledHeight:Number):void
		{
		}
		
		override protected function get border():DisplayObject
		{
			return null;
		}
	}
}