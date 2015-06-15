package gr.ictpro.mall.client.desktop
{
	
	import gr.ictpro.mall.client.desktop.skins.ButtonSkin;
	import gr.ictpro.mall.client.desktop.skins.FormItemSkin;
	import gr.ictpro.mall.client.desktop.skins.HScrollBarSkin;
	import gr.ictpro.mall.client.desktop.skins.ImageSkin;
	import gr.ictpro.mall.client.desktop.skins.ListSkin;
	import gr.ictpro.mall.client.desktop.skins.SkinnableContainerSkin;
	import gr.ictpro.mall.client.desktop.skins.SkinnablePopUpContainerSkin;
	import gr.ictpro.mall.client.desktop.skins.TextInputSkin;
	import gr.ictpro.mall.client.desktop.skins.VScrollBarSkin;
	import gr.ictpro.mall.client.model.IDevice;
	
	import spark.skins.SparkSkin;

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
	}
}