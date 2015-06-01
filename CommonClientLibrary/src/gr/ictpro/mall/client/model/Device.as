package gr.ictpro.mall.client.model
{
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

		private static var _curDensity:Number = FlexGlobals.topLevelApplication.runtimeDPI; 
		private static var _curAppDPI:Number = FlexGlobals.topLevelApplication.applicationDPI; 

		public static function set device(device:IDevice):void
		{
			_device = device;
		}
		
		public function Device()
		{
			throw new Error("Cannot intatiate class");
		}
		
		public static function getScaledSize(defaultSize:int):int
		{
			return (defaultSize==0?12:defaultSize) * _curDensity/_curAppDPI;
		}
		
		public static function get isAndroid():Boolean
		{
			if(_device != null) {
				return _device.isAndroid;
			}
			return false;
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