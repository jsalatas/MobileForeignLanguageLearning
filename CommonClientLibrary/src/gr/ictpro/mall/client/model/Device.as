package gr.ictpro.mall.client.model
{
	import flash.geom.ColorTransform;
	import flash.text.ReturnKeyLabel;
	
	import mx.core.FlexGlobals;
	
	import spark.skins.SparkSkin;
	import spark.skins.spark.ButtonSkin;
	import spark.skins.spark.FormItemSkin;
	import spark.skins.spark.HScrollBarSkin;
	import spark.skins.spark.ImageSkin;
	import spark.skins.spark.ListSkin;
	import spark.skins.spark.ScrollerSkin;
	import spark.skins.spark.SkinnableContainerSkin;
	import spark.skins.spark.SkinnablePopUpContainerSkin;
	import spark.skins.spark.TextInputSkin;
	import spark.skins.spark.VScrollBarSkin;

	public class Device
	{
		public static var _device:IDevice;
		public static var _scale:Number;
		private static var _curDensity:Number = FlexGlobals.topLevelApplication.runtimeDPI; 
		private static var _curAppDPI:Number = 160; 
		
		private static var _settings:Settings; 

		public static function set device(device:IDevice):void
		{
			_device = device;
		}
		
		public function Device()
		{
			throw new Error("Cannot intatiate class");
		}
		
		[Inline]
		public static function getScaledSize(size:int):int
		{
			return size * _curDensity/_curAppDPI;
		}
		
		[Inline]
		public static function getUnScaledSize(size:int):int
		{
			return size * _curAppDPI / _curDensity;
		}
		
		[Inline]
		public static function getDefaultScaledFontSize():int
		{
			return getScaledSize(isAndroid?9:12);
		}
		
		public static function get isAndroid():Boolean
		{
			if(_device != null) {
				return _device.isAndroid;
			}
			return false;
		}
		
		[Inline]
		public static function get defaultColor():int
		{
			var color:int= 0x000077;
			if (_settings != null && _settings.user != null && !isNaN(_settings.user.color)) {
				color = _settings.user.color;
			}
			return color;
		}

		[Inline]
		public static function get defaultColorTransform():ColorTransform
		{
			var transform:ColorTransform = new ColorTransform();
			transform.color = defaultColor;
			return transform;
		}

		public static function set settings(settings:Settings):void
		{
			_settings = settings;
		}
		
		public static function get formItemSkin():Class
		{
			if(_device != null) {
				return _device.formItemSkin;
			}
			return FormItemSkin;
		}
		
		public static function get skinnableContainerSkin():Class
		{
			if(_device != null) {
				return _device.skinnableContainerSkin;
			}
			return SkinnableContainerSkin;
		}
		
		public static function get textInputSkin():Class
		{
			if(_device != null) {
				return _device.textInputSkin;
			}
			return TextInputSkin;
		}
		
		public static function get buttonSkin():Class
		{
			if(_device != null) {
				return _device.buttonSkin;
			}
			return ButtonSkin;
		}
		
		public static function get imageSkin():Class
		{
			if(_device != null) {
				return _device.imageSkin;
			}
			return ImageSkin;
		}
		
		public static function get listSkin():Class
		{
			if(_device != null) {
				return _device.listSkin;
			}
			return ListSkin;
		}
		
		public static function get skinnablePopUpContainerSkin():Class
		{
			if(_device != null) {
				return _device.skinnablePopUpContainerSkin;
			}
			return SkinnablePopUpContainerSkin;
		}

		public static function get vScrollBarSkin():Class
		{
			if(_device != null) {
				return _device.vScrollBarSkin;
			}
			return VScrollBarSkin;
		}

		public static function get hScrollBarSkin():Class
		{
			if(_device != null) {
				return _device.hScrollBarSkin;
			}
			return HScrollBarSkin;
		}
	}
}