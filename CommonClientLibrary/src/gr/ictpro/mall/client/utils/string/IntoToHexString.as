package gr.ictpro.mall.client.utils.string
{
	public class IntoToHexString
	{
		public function IntoToHexString()
		{
			throw new Error("Cannot instantiate class");
		}
		
		public static function convertToHex(value:int):String
		{
			var res:String = value.toString(16);
			while(res.length<6) {
				res = "0" + res;
			}
			res = "0x" + res;
			return res;
		}
	}
}