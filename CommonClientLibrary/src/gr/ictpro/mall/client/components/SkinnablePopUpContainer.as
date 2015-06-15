package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.SkinnablePopUpContainer;
	
	public class SkinnablePopUpContainer extends spark.components.SkinnablePopUpContainer
	{
		public function SkinnablePopUpContainer()
		{
			super();
			super.setStyle("skinClass", Device.skinnablePopUpContainerSkin);
			super.setStyle("fontSize", Device.getDefaultScaledFontSize() * (Device.isAndroid?2:1));
		}
		
		override public function setStyle(styleProp:String, newValue:*):void
		{
			if(styleProp == "fontSize") {
				newValue = Device.getScaledSize(newValue) * (Device.isAndroid?2:1);
			}
			super.setStyle(styleProp, newValue);
		}
		
		[Bindable(event="HeightScaled")]
		override public function set height(value:Number):void
		{
			super.height = Device.getScaledSize(value * (Device.isAndroid?2:1));
		}
		
		[Bindable(event="HeightScaled")]
		public function get definedHeight():Number
		{
			return Device.getUnScaledSize(super.height / (Device.isAndroid?2:1));	
		}
		
		[Bindable(event="WidthScaled")]
		override public function set width(value:Number):void
		{
			super.width = Device.getScaledSize(value * (Device.isAndroid?2:1));
		}
		
		[Bindable(event="WidthScaled")]
		public function get definedWidth():Number
		{
			return Device.getUnScaledSize(super.width / (Device.isAndroid?2:1));	
		}
		
		[Bindable(event="LeftScaled")]
		override public function set left(value:Object):void
		{
			if(value != null && value is Number) {
				super.left = Device.getScaledSize((value as Number) * (Device.isAndroid?2:1));	
			} else {
				super.left = value;
			}
		}
		
		[Bindable(event="LeftScaled")]
		public function get definedLeft():Object
		{
			if(super.left != null && super.left is Number) {
				return Device.getUnScaledSize((super.left as Number) / (Device.isAndroid?2:1));
			}
			return super.left; 
		}
		
		[Bindable(event="TopScaled")]
		override public function set top(value:Object):void
		{
			if(value != null && value is Number) {
				super.top = Device.getScaledSize((value as Number) * (Device.isAndroid?2:1));	
			} else {
				super.top = value;
			}
		}
		
		[Bindable(event="TopScaled")]
		public function get definedTop():Object
		{
			if(super.top != null && super.top is Number) {
				return Device.getUnScaledSize((super.top as Number) / (Device.isAndroid?2:1));
			}
			return super.top; 
		}
		
		[Bindable(event="BottomScaled")]
		override public function set bottom(value:Object):void
		{
			if(value != null && value is Number) {
				super.bottom = Device.getScaledSize((value as Number) * (Device.isAndroid?2:1));	
			} else {
				super.bottom = value;
			}
		}
		
		[Bindable(event="BottomScaled")]
		public function get definedBottom():Object
		{
			if(super.bottom != null && super.bottom is Number) {
				return Device.getUnScaledSize((super.bottom as Number) / (Device.isAndroid?2:1));
			}
			return super.bottom; 
		}
		
		[Bindable(event="RightScaled")]
		override public function set right(value:Object):void
		{
			if(value != null && value is Number) {
				super.right = Device.getScaledSize((value as Number) * (Device.isAndroid?2:1));	
			} else {
				super.right = value;
			}
		}
		
		[Bindable(event="RightScaled")]
		public function get definedRight():Object
		{
			if(super.right != null && super.right is Number) {
				return Device.getUnScaledSize((super.right as Number) / (Device.isAndroid?2:1));
			}
			return super.right; 
		}
		
		[Bindable(event="XScaled")]
		override public function set x(value:Number):void
		{
			super.x = Device.getScaledSize(value * (Device.isAndroid?2:1));
		}
		
		[Bindable(event="XScaled")]
		public function get definedX():Number
		{
			return Device.getUnScaledSize(super.x / (Device.isAndroid?2:1));	
		}
		
		[Bindable(event="YScaled")]
		override public function set y(value:Number):void
		{
			super.y = Device.getScaledSize(value * (Device.isAndroid?2:1));
		}
		
		[Bindable(event="TScaled")]
		public function get definedY():Number
		{
			return Device.getUnScaledSize(super.y / (Device.isAndroid?2:1));	
		}
	}
}