package org.bigbluebutton.view.navigation.pages.presentation
{
	public class SlideModel
	{
		public static const MYSTERY_NUM:Number = 2;
		
		public static const MAX_ZOOM_PERCENT:Number = 400;
		public static const HUNDRED_PERCENT:Number = 100;
		
		public var viewportX:Number = 0;
		public var viewportY:Number = 0;
		public var viewportW:Number = 0;
		public var viewportH:Number = 0;
		
		public var loaderW:Number = 0;
		public var loaderH:Number = 0;
		public var loaderX:Number = 0;
		public var loaderY:Number = 0;
		
		public var viewedRegionX:Number = 0;
		public var viewedRegionY:Number = 0;
		public var viewedRegionW:Number = HUNDRED_PERCENT;
		public var viewedRegionH:Number = HUNDRED_PERCENT;
		
		private var _pageOrigW:Number = 0;
		private var _pageOrigH:Number = 0;
		private var _calcPageW:Number = 0;
		private var _calcPageH:Number = 0;
		private var _calcPageX:Number = 0;
		private var _calcPageY:Number = 0;
		private var _parentW:Number = 0;
		private var _parentH:Number = 0;
		
		public function SlideModel()
		{
		}
		
		public function resetForNewSlide(pageWidth:Number, pageHeight:Number):void {
			_pageOrigW = pageWidth;
			_pageOrigH = pageHeight;
		}
		
		public function parentChange(parentW:Number, parentH:Number):void {
			viewportW = _parentW = parentW;
			viewportH = _parentH = parentH;
		}
		
		public function calculateViewportNeededForRegion(regionW:Number, regionH:Number):void {			
			var vrwp:Number = _pageOrigW * (regionW/HUNDRED_PERCENT);
			var vrhp:Number = _pageOrigH * (regionH/HUNDRED_PERCENT);
			
			if (_parentW < _parentH) {
				viewportW = _parentW;
				viewportH = (vrhp/vrwp)*_parentW;				 
				if (_parentH < viewportH) {
					viewportH = _parentH;
					viewportW = ((vrwp * viewportH)/vrhp);
				}
			} else {
				viewportH = _parentH;
				viewportW = (vrwp/vrhp)*_parentH;
				if (_parentW < viewportW) {
					viewportW = _parentW;
					viewportH = ((vrhp * viewportW)/vrwp);
				}
			}
		}
		
		public function displayViewerRegion(x:Number, y:Number, regionW:Number, regionH:Number):void {
			_calcPageW = viewportW/(regionW/HUNDRED_PERCENT);
			_calcPageH = viewportH/(regionH/HUNDRED_PERCENT);
			_calcPageX = (x/HUNDRED_PERCENT) * _calcPageW * MYSTERY_NUM;
			_calcPageY = (y/HUNDRED_PERCENT) * _calcPageH * MYSTERY_NUM;
			
			/**
			 * I have no idea why I need to multiply the x and y percentages by 2, but I 
			 * do. I think it is a bug in 0.81, but I can't change that.
			 *     - capilkey March 11, 2015
			 */
		}
		
		public function calculateViewportXY():void {
			viewportX = SlideCalcUtil.calculateViewportX(viewportW, _parentW);
			viewportY = SlideCalcUtil.calculateViewportY(viewportH, _parentH);
		}
		
		public function displayPresenterView():void {
			loaderX = Math.round(_calcPageX);
			loaderY = Math.round(_calcPageY);
			loaderW = Math.round(_calcPageW);
			loaderH = Math.round(_calcPageH);
		}
		
		public function onZoom(zoomValue:Number, mouseX:Number, mouseY:Number):void {
			
			// Absolute x and y positions of the mouse over the (enlarged) slide:
			var absXcoordInPage:Number = Math.abs(_calcPageX) * MYSTERY_NUM + mouseX;
			var absYcoordInPage:Number = Math.abs(_calcPageY) * MYSTERY_NUM + mouseY;

			// Relative position of mouse over the slide. For example, if your slide is 1000 pixels wide, 
			// and your mouse has an absolute x-coordinate of 700, then relXcoordInPage will be 0.7 :
			var relXcoordInPage:Number = absXcoordInPage / _calcPageW; 
			var relYcoordInPage:Number = absYcoordInPage / _calcPageH;
			
			// Relative position of mouse in the view port (same as above, but with the view port):
			var relXcoordInViewport:Number = mouseX / viewportW;
			var relYcoordInViewport:Number = mouseY / viewportH;
			
			if (isPortraitDoc()) {
					_calcPageW = viewportW * zoomValue / HUNDRED_PERCENT;
					_calcPageH = (_calcPageW/_pageOrigW)*_pageOrigH;
			} else {
					_calcPageW = viewportW * zoomValue / HUNDRED_PERCENT;
					_calcPageH = (_calcPageW/_pageOrigW)*_pageOrigH;
			}
			
			absXcoordInPage = relXcoordInPage * _calcPageW;
			absYcoordInPage = relYcoordInPage * _calcPageH;
			
			_calcPageX = -((absXcoordInPage - mouseX) / MYSTERY_NUM);
			_calcPageY = -((absYcoordInPage - mouseY) / MYSTERY_NUM);
			
			doWidthBoundsDetection();
			doHeightBoundsDetection();
			
			calcViewedRegion();

		}
		
		private function isPortraitDoc():Boolean {
			return _pageOrigH > _pageOrigW;
		}
		
		private function doWidthBoundsDetection():void {
			if (_calcPageX >= 0) {
				// Don't let the left edge move inside the view.
				_calcPageX = 0;
			} else if ((_calcPageW + _calcPageX * MYSTERY_NUM) < viewportW) {
				// Don't let the right edge move inside the view.
				_calcPageX = (viewportW - _calcPageW) / MYSTERY_NUM;
			} else {
				// Let the move happen.
			}			
		}
		
		private function doHeightBoundsDetection():void {
			if (_calcPageY >= 0) {
				// Don't let the top edge move into the view.
				_calcPageY = 0;
			} else if ((_calcPageH + _calcPageY * MYSTERY_NUM) < viewportH) {
				// Don't let the bottome edge move into the view.
				_calcPageY = (viewportH - _calcPageH) / MYSTERY_NUM;
			} else {
				// Let the move happen.
			}	
		}

		private function calcViewedRegion():void {
			viewedRegionW = SlideCalcUtil.calcViewedRegionWidth(viewportW, _calcPageW);
			viewedRegionH = SlideCalcUtil.calcViewedRegionHeight(viewportH, _calcPageH);
			viewedRegionX = SlideCalcUtil.calcViewedRegionX(_calcPageX, _calcPageW);
			viewedRegionY = SlideCalcUtil.calcViewedRegionY(_calcPageY, _calcPageH);
		}
		
		public function adjustSlideAfterParentResized():void {			
				calculateViewportSize();
				calculateViewportXY();
				_calcPageW = (viewportW/viewedRegionW) * HUNDRED_PERCENT;
				_calcPageH = (_pageOrigH/_pageOrigW) * _calcPageW;
				calcViewedRegion();
				onResizeMove();
		}
		
		public function switchToFitToPage(ftp:Boolean):void {
			
			calculateViewportSize();
			calculateViewportXY();			
		}

		public function calculateViewportSize():void {
			viewportW = _parentW;
			viewportH = _parentH;
			
				viewportH = (viewportW/_pageOrigW)*_pageOrigH;
				if (viewportH > _parentH) 
					viewportH = _parentH;
		}
		
		private function onResizeMove():void {		
			doWidthBoundsDetection();
			doHeightBoundsDetection();
		}

	}	
	

}