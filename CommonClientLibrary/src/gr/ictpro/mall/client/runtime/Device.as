package gr.ictpro.mall.client.runtime
{
	import flash.display.StageOrientation;
	import flash.geom.ColorTransform;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.text.ReturnKeyLabel;
	
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	
	import spark.skins.spark.ButtonSkin;
	import spark.skins.spark.CheckBoxSkin;
	import spark.skins.spark.DropDownListSkin;
	import spark.skins.spark.FormItemSkin;
	import spark.skins.spark.HScrollBarSkin;
	import spark.skins.spark.HSliderSkin;
	import spark.skins.spark.ImageSkin;
	import spark.skins.spark.ListSkin;
	import spark.skins.spark.SkinnableContainerSkin;
	import spark.skins.spark.SkinnablePopUpContainerSkin;
	import spark.skins.spark.TextAreaSkin;
	import spark.skins.spark.TextInputSkin;
	import spark.skins.spark.ToggleButtonSkin;
	import spark.skins.spark.VScrollBarSkin;
	
	import gr.ictpro.mall.client.view.ShellView;

	public class Device
	{
		public static var _device:IDevice;
		public static var fileDialog:IFileDialog;
		public static var _scale:Number;
		private static var _curDensity:Number = FlexGlobals.topLevelApplication.runtimeDPI; 
		private static var _curAppDPI:Number = 160; 
		
		public static var cameras:ArrayList = new ArrayList();
		
		
		private static var _settings:RuntimeSettings; 

		private static var _translations:Translation = new Translation();
		
		public static var shellView:ShellView; 

		public static function get translations():Translation
		{
			return _translations;
		}

		public static function set device(device:IDevice):void
		{
			_device = device;
		}
		
		public static function calcCameraRotation(cameraName:String, stageOrientation:String):Number {
			var res:Number = 0;
			if(Device.isAndroid) {
				var camera:Camera = Camera.getCamera(cameraName);
				var cameraPosition:String = camera!=null?camera.position:"";
				if(stageOrientation == StageOrientation.DEFAULT || stageOrientation == StageOrientation.UPSIDE_DOWN) {
					if(cameraPosition == CameraPosition.FRONT) {
						res = 270;
					} else if(cameraPosition == CameraPosition.BACK) {
						res = 90;
					}
				}
			}
			
			return res;
		}
		
		public function Device()
		{
			throw new Error("Cannot intatiate class");
		}
		
		[Inline]
		public static function get language():String
		{
			return _device.language;
		}
		
		[Inline]
		public static function get locale():String
		{
			return _device.locale;
		}
		
		[Inline]
		public static function getScaledSize(size:int):int
		{
			return (size * _curDensity/_curAppDPI) * (Device.isAndroid?2:1);
		}
		
		[Inline]
		public static function getUnScaledSize(size:int):int
		{
			return (size * _curAppDPI / _curDensity) / (Device.isAndroid?2:1);
		}
		
		[Inline]
		public static function getDefaultScaledFontSize():int
		{
			return getScaledSize(isAndroid?9:12);
		}
		
		[Inline]
		public static function getDefaultUnscaledFontSize():int
		{
			return isAndroid?9:12;
		}
		
		[Inline]
		public static function get isAndroid():Boolean
		{
			if(_device != null) {
				return _device.isAndroid;
			}
			return false;
		}
		
		[Inline]
		public static function getDefaultColor(alpha:Number = 1):int
		{
			var color:int= 0x000066;
			if (_settings != null && _settings.user != null && !isNaN(_settings.user.profile.color)) {
				color = _settings.user.profile.color;
			}
			
			if(alpha == 1) 
				return color;

			// extract RGB values 
			var r:Number = ((color >> 16) & 0xFF);
			var g:Number = ((color >> 8) & 0xFF);
			var b:Number = (color & 0xFF);
				
			// blend with alpha in a white background
			r = 255 + (r - 255) * alpha;
			g = 255 + (g - 255) * alpha;
			b = 255 + (b - 255) * alpha;
			
			return ((r << 16) | (g << 8) | b);
		}

		[Inline]
		public static function getDefaultColorTransform(alpha:Number = 1):ColorTransform
		{
			var transform:ColorTransform = new ColorTransform();
			transform.color = getDefaultColor(alpha);
			return transform;
		}

		public static function set settings(settings:RuntimeSettings):void
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

		public static function get toggleButtonSkin():Class
		{
			if(_device != null) {
				return _device.toggleButtonSkin;
			}
			return ToggleButtonSkin;
		}

		public static function get buttonBarSkin():Class
		{
			if(_device != null) {
				return _device.buttonBarSkin;
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

		public static function get hSliderSkin():Class
		{
			if(_device != null) {
				return _device.hSliderSkin;
			}
			return HSliderSkin;
		}

		public static function get dropDownSkin():Class
		{
			if(_device != null) {
				return _device.dropDownSkin;
			}
			return DropDownListSkin;
		}

		public static function get colorDropDownSkin():Class
		{
			if(_device != null) {
				return _device.colorDropDownSkin;
			}
			return DropDownListSkin;
		}
		
		public static function get checkBoxSkin():Class
		{
			if(_device != null) {
				return _device.checkBoxSkin;
			}
			return CheckBoxSkin;
		}

		public static function get textAreaSkin():Class
		{
			if(_device != null) {
				return _device.textAreaSkin;
			}
			return TextAreaSkin;
		}

	}
}