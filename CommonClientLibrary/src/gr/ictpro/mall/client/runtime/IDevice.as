package gr.ictpro.mall.client.runtime
{
	public interface IDevice
	{
		function get isAndroid():Boolean;
		function get formItemSkin():Class;
		function get skinnableContainerSkin():Class;
		function get textInputSkin():Class;
		function get buttonSkin():Class;
		function get buttonBarSkin():Class;
		function get imageSkin():Class;
		function get listSkin():Class;
		function get skinnablePopUpContainerSkin():Class;
		function get vScrollBarSkin():Class;
		function get hScrollBarSkin():Class;
		function get dropDownSkin():Class;
		function get colorDropDownSkin():Class;
		function get checkBoxSkin():Class;
		function get textAreaSkin():Class;
		function get language():String;
		function get locale():String;
	}
}