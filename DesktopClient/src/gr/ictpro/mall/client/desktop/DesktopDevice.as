package gr.ictpro.mall.client.desktop
{
	
	import flash.system.Capabilities;
	
	import gr.ictpro.jsalatas.ane.locale.Locale;
	import gr.ictpro.mall.client.desktop.skins.ButtonBarSkin;
	import gr.ictpro.mall.client.desktop.skins.ButtonSkin;
	import gr.ictpro.mall.client.desktop.skins.CheckBoxSkin;
	import gr.ictpro.mall.client.desktop.skins.ColorDropDownSkin;
	import gr.ictpro.mall.client.desktop.skins.DropDownSkin;
	import gr.ictpro.mall.client.desktop.skins.FormItemSkin;
	import gr.ictpro.mall.client.desktop.skins.HScrollBarSkin;
	import gr.ictpro.mall.client.desktop.skins.ImageSkin;
	import gr.ictpro.mall.client.desktop.skins.ListSkin;
	import gr.ictpro.mall.client.desktop.skins.SkinnableContainerSkin;
	import gr.ictpro.mall.client.desktop.skins.SkinnablePopUpContainerSkin;
	import gr.ictpro.mall.client.desktop.skins.TextAreaSkin;
	import gr.ictpro.mall.client.desktop.skins.TextInputSkin;
	import gr.ictpro.mall.client.desktop.skins.VScrollBarSkin;
	import gr.ictpro.mall.client.runtime.IDevice;

	public class DesktopDevice implements IDevice
	{
		public function DesktopDevice()
		{
		}
		
		public function get isAndroid():Boolean
		{
			return false;
		}

		public function get formItemSkin():Class
		{
			return FormItemSkin;			
		}
		
		public function get skinnableContainerSkin():Class
		{
			return SkinnableContainerSkin;						
		}
			
		public function get textInputSkin():Class
		{
			return TextInputSkin;
		}
			
		public function get buttonSkin():Class
		{
			return ButtonSkin;
		}
			
		public function get buttonBarSkin():Class
		{
			return ButtonBarSkin;
		}
		
		public function get imageSkin():Class
		{
			return ImageSkin;
		}
			
		public function get listSkin():Class
		{
			return ListSkin;
		}
			
		public function get skinnablePopUpContainerSkin():Class
		{
			return SkinnablePopUpContainerSkin;
		}
		
		public function get vScrollBarSkin():Class 
		{
			return VScrollBarSkin;
		}

		public function get hScrollBarSkin():Class 
		{
			return HScrollBarSkin;
		}
		
		public function get dropDownSkin():Class
		{
			return DropDownSkin;
		}

		public function get colorDropDownSkin():Class
		{
			return ColorDropDownSkin;
		}

		public function get checkBoxSkin():Class
		{
			return CheckBoxSkin;
		}

		public function get textAreaSkin():Class
		{
			return TextAreaSkin;
		}
		
		public function get language():String
		{
			return Capabilities.languages[0];
		}

		private var _locale:String = null;

		public function get locale():String
		{
			if(_locale == null){
				var locale:Locale = new Locale();
				_locale = locale.getLocale();
			}
			return _locale;
		}
		
	}
}