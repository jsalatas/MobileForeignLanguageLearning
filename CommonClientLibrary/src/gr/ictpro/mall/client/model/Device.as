package gr.ictpro.mall.client.model
{
	import flash.text.ReturnKeyLabel;
	
	import mx.core.FlexGlobals;
	
	import spark.skins.SparkSkin;
	import spark.skins.spark.ButtonSkin;
	import spark.skins.spark.FormItemSkin;
	import spark.skins.spark.ImageSkin;
	import spark.skins.spark.ListSkin;
	import spark.skins.spark.SkinnableContainerSkin;
	import spark.skins.spark.SkinnablePopUpContainerSkin;
	import spark.skins.spark.TextInputSkin;

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
			trace("get isAndroid(): null");
			return false;
		}

		public static function get formItemSkin():Class
		{
			if(_device != null) {
				return _device.formItemSkin;
			}
			trace("get formItemSkin(): null");
			return FormItemSkin;
		}
		
		public static function get skinnableContainerSkin():Class
		{
			if(_device != null) {
				return _device.skinnableContainerSkin;
			}
			trace("get skinnableContainerSkin(): null");
			return SkinnableContainerSkin;
		}
		
		public static function get textInputSkin():Class
		{
			if(_device != null) {
				return _device.textInputSkin;
			}
			trace("get textInputSkin(): null");
			return TextInputSkin;
		}
		
		public static function get buttonSkin():Class
		{
			if(_device != null) {
				return _device.buttonSkin;
			}
			trace("get buttonSkin(): null");
			return ButtonSkin;
		}
		
		public static function get imageSkin():Class
		{
			if(_device != null) {
				return _device.imageSkin;
			}
			trace("get imageSkin(): null");
			return ImageSkin;
		}
		
		public static function get listSkin():Class
		{
			if(_device != null) {
				return _device.listSkin;
			}
			trace("get listSkin(): null");
			return ListSkin;
		}
		
		public static function get skinnablePopUpContainerSkin():Class
		{
			if(_device != null) {
				return _device.skinnablePopUpContainerSkin;
			}
			trace("get skinnablePopUpContainerSkin(): null");
			return SkinnablePopUpContainerSkin;
		}
	}
}