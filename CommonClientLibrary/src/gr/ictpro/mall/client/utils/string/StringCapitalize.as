package gr.ictpro.mall.client.utils.string
{
	public class StringCapitalize
	{
		public function StringCapitalize()
		{
			throw new Error("Cannot instantiate class");
		}
		
		public static function capitalizeWords(input:String):String
		{
			var strArray:Array = input.split(' ');
			var newArray:Array = [];
			for (var str:String in strArray) 
			{
				newArray.push((strArray[str].charAt(0) as String).toUpperCase() + strArray[str].slice(1));
			}
			return newArray.join(' ');
		}
	}
}