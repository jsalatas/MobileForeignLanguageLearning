package gr.ictpro.mall.client.components.renderers
{
	import mx.core.mx_internal;
	
	import spark.components.LabelItemRenderer;
	
	use namespace mx_internal;
	
	public class LabelItemRenderer extends spark.components.LabelItemRenderer
	{
		private var _topSeparatorColor:uint = 0xFFFFFF;
		private var _topSeparatorAlpha:Number = .3;
		private var _bottomSeparatorColor:uint = 0x000000;
		private var _bottomSeparatorAlpha:Number = .3;

		
		public function LabelItemRenderer()
		{
			super();
		}
		
		override protected function drawBorder(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// draw separators
			// don't draw top separator for down and selected states
			if (!(selected || down))
			{
				graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
				graphics.drawRect(0, 0, unscaledWidth, 1);
				graphics.endFill();
			}
			
			graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
			graphics.drawRect(0, unscaledHeight - (isLastItem ? 0 : 1), unscaledWidth, 1);
			graphics.endFill();
			
			
			// add extra separators to the first and last items so that 
			// the list looks correct during the scrolling bounce/pull effect
			// top
			if (itemIndex == 0)
			{
				graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
				graphics.drawRect(0, -1, unscaledWidth, 1);
				graphics.endFill(); 
			}
			
			// bottom
			if (isLastItem)
			{
				// we want to offset the bottom by 1 so that we don't get
				// a double line at the bottom of the list if there's a 
				// border
				graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
				graphics.drawRect(0, unscaledHeight + 1, unscaledWidth, 1);
				graphics.endFill(); 
			}
		}
		
		public function get topSeparatorColor():uint
		{
			return this._topSeparatorColor;	
		}
		
		public function set topSeparatorColor(topSeparatorColor:uint): void
		{
			this._topSeparatorColor = topSeparatorColor;	
		}
		
		public function get topSeparatorAlpha():Number
		{
			return this._topSeparatorAlpha;
		}
		
		public function set topSeparatorAlpha(topSeparatorAlpha:Number):void
		{
			this._topSeparatorAlpha = topSeparatorAlpha;
		}

		public function get bottomSeparatorColor():uint
		{
			return this._bottomSeparatorColor;	
		}
		
		public function set bottomSeparatorColor(bottomSeparatorColor:uint): void
		{
			this._bottomSeparatorColor = bottomSeparatorColor;	
		}
		
		public function get bottomSeparatorAlpha():Number
		{
			return this._bottomSeparatorAlpha;
		}
		
		public function set bottomSeparatorAlpha(bottomSeparatorAlpha:Number):void
		{
			this._bottomSeparatorAlpha = bottomSeparatorAlpha;
		}

	
	} 

		
}