package org.bigbluebutton.view.navigation.pages.presentation
{
	public class SlideCalcUtil
	{
		public static const HUNDRED_PERCENT:Number = 100;
		// After lots of trial and error on why synching doesn't work properly, I found I had to 
		// multiply the coordinates by 2. There's something I don't understand probably on the
		// canvas coordinate system. (ralam feb 22, 2012)
		public static const MYSTERY_NUM:int = 2;
		
		public static function calculateViewportX(vpw:Number, pw:Number):Number {
			if (vpw == pw) {
				return 0;
			} else {
				return (pw - vpw) / MYSTERY_NUM;
			}
		}
		
		public static function calculateViewportY(vph:Number, ph:Number):Number {			
			if (vph == ph) {
				return 0;
			} else {
				return (ph - vph) / MYSTERY_NUM;
			}
		}
		
		public static function calcViewedRegionWidth(vpw:Number, cpw:Number):Number {
			var width:Number = (vpw/cpw) * HUNDRED_PERCENT;								
			if (width > HUNDRED_PERCENT) return HUNDRED_PERCENT;				
			return width;					
		}
		
		public static function calcViewedRegionHeight(vph:Number, cph:Number):Number {
			var height:Number = (vph/cph) * HUNDRED_PERCENT;							
			if (height > HUNDRED_PERCENT) return HUNDRED_PERCENT;			
			return height;		
		}		

		public static function calcViewedRegionX(cpx:Number, cpw:Number):Number {
			return (cpx * HUNDRED_PERCENT) / cpw;
		}
		
		public static function calcViewedRegionY(cpy:Number, cph:Number):Number {
			return (cpy * HUNDRED_PERCENT) / cph;
		}

	}
}