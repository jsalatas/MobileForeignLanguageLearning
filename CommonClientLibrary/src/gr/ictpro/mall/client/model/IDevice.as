package gr.ictpro.mall.client.model
{
	public interface IDevice
	{
		function get isAndroid():Boolean;
		function get formItemSkin():Class;
		function get skinnableContainerSkin():Class;
		function get textInputSkin():Class;
		function get buttonSkin():Class;
		function get imageSkin():Class;
		function get listSkin():Class;
		function get skinnablePopUpContainerSkin():Class;
		
	}
}