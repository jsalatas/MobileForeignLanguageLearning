package gr.ictpro.mall.client.model
{
	public class DeviceType
	{
		private static var _isAndroid:Boolean = false;
		
		public function DeviceType()
		{
			throw new Error("This should be used as static class");
		}
		
		public static function set isAndroid(isAndroid:Boolean):void
		{
			_isAndroid = isAndroid;
		}

		public static function set isDesktop(isDesktop:Boolean):void
		{
			_isAndroid = !isDesktop;
		}

		public static function get isAndroid():Boolean
		{
			return _isAndroid;
		}

		public static function get isDesktop():Boolean
		{
			return !_isAndroid;
		}

	}
}