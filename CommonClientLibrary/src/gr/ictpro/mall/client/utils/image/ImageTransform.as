package gr.ictpro.mall.client.utils.image
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class ImageTransform
	{
		public function ImageTransform()
		{
			throw new Error("Cannot instantiate class");
		}
		
		public static function transform(bitmapData:BitmapData, orientation:int):BitmapData
		{
			var res:BitmapData;
			
			switch(orientation)
			{
				case 1:
				{
					res = bitmapData;	
					break;
				}
				case 2:
				{
					res = flip(bitmapData, "x");	
					break;
				}
				case 3:
				{
					res = flip(flip(bitmapData, "x"), "y");
					break;
				}
				case 4:
				{
					res = flip(bitmapData, "y");
					break;
				}
				case 5:
				{
					res = flip(rotate(bitmapData, 90), "x");
					break;
				}
				case 6:
				{
					res = rotate(bitmapData, 90);
					break;
				}
				case 7:
				{
					res = flip(rotate(bitmapData, 90), "y");
					break;
				}
				case 8:
				{
					res = rotate(bitmapData, 270);
					break;
				}
				default:
				{
					res = bitmapData;
					break;
				}
			}
			
			return res;
			
		}
		
		private static function flip(original:BitmapData, axis:String):BitmapData
		{
			var res:BitmapData = new BitmapData(original.width, original.height, true, 0);
			var matrix:Matrix
			if(axis == "x"){
				matrix = new Matrix( -1, 0, 0, 1, original.width, 0);
			} else {
				matrix = new Matrix( 1, 0, 0, -1, 0, original.height);
			}
			res.draw(original, matrix, null, null, null, true);
			
			return res;
		}
		
		private static function rotate(original:BitmapData, degrees:int):BitmapData
		{
			var res:BitmapData = new BitmapData(original.height, original.width, true);
			var matrix:Matrix = new Matrix();
			matrix.rotate( degrees*Math.PI/180.0);
			
			if(degrees == 90){
				matrix.translate(original.height, 0);
			} else if(degrees == -90 || degrees == 270) {
				matrix.translate( 0, original.width );
			} else if(degrees == 180) {
				res = new BitmapData(original.width, original.height, true);
				matrix.translate(original.width, original.height);
			}
			
			res.draw(original, matrix, null, null, null, true);
			return res;
		}
	}
}