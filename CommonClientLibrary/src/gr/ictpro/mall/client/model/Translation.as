package gr.ictpro.mall.client.model
{
	import mx.utils.StringUtil;

	public class Translation
	{
		public function Translation()
		{
		}
		
		public static function getTranslation(originalText:String, ... args):String
		{
			var res:String = StringUtil.substitute(originalText, args);
			
			return res;
		}
	}
}