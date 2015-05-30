package gr.ictpro.mall.client.components
{
	import mx.graphics.SolidColorStroke;
	
	public class SolidColorStroke extends mx.graphics.SolidColorStroke
	{
		public function SolidColorStroke(color:uint=0, weight:Number=1, alpha:Number=1.0, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String="round", joints:String="round", miterLimit:Number=3)
		{
			super(color, weight, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
	}
}