package gr.ictpro.mall.client.mobile
{
	import gr.ictpro.mall.client.mobile.skins.ButtonSkin;
	import gr.ictpro.mall.client.mobile.skins.ColorDropDownSkin;
	import gr.ictpro.mall.client.mobile.skins.DropDownSkin;
	import gr.ictpro.mall.client.mobile.skins.FormItemSkin;
	import gr.ictpro.mall.client.mobile.skins.HScrollBarSkin;
	import gr.ictpro.mall.client.mobile.skins.ImageSkin;
	import gr.ictpro.mall.client.mobile.skins.ListSkin;
	import gr.ictpro.mall.client.mobile.skins.SkinnableContainerSkin;
	import gr.ictpro.mall.client.mobile.skins.SkinnablePopUpContainerSkin;
	import gr.ictpro.mall.client.mobile.skins.TextInputSkin;
	import gr.ictpro.mall.client.mobile.skins.VScrollBarSkin;
	import gr.ictpro.mall.client.model.IDevice;
	
	public class MobileDevice implements IDevice
	{
		public function MobileDevice()
		{
		}
		
		public function get isAndroid():Boolean
		{
			return true;
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

	}
}