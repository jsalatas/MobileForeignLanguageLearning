package gr.ictpro.mall.client.utils.collections
{
	public class ArrayUtils
	{
		public function ArrayUtils()
		{
		}

		public static function getItemIndexByProperty(array:Array, property:String, value:String):int
		{
			for (var i:int = 0; i < array.length; i++)
			{
				var obj:Object = Object(array[i])
				if (obj[property] == value)
					return i;
			}
			return -1;
		}
	}
}