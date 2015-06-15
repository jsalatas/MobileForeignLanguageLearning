package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import spark.components.FormItem;
	import spark.skins.spark.StackedFormItemSkin;
	
	public class FormItem extends spark.components.FormItem
	{
		public function FormItem()
		{
			super();
			super.setStyle("skinClass", Device.formItemSkin);
			super.setStyle("fontSize", Device.getDefaultScaledFontSize());
			super.setStyle("color", Device.defaultColor);

			if(Device.isAndroid) {
				super.setStyle("textAlign", "left");
			} else {
				super.setStyle("textAlign", "right");
			}
		}

		override public function setStyle(styleProp:String, newValue:*):void
		{
			if(styleProp == "fontSize") {
				newValue = Device.getScaledSize(newValue);
			}
			super.setStyle(styleProp, newValue);
		}

		[Bindable(event="HeightScaled")]
		override public function set height(value:Number):void
		{
			super.height = Device.getScaledSize(value);
		}
		
		[Bindable(event="HeightScaled")]
		public function get definedHeight():Number
		{
			return Device.getUnScaledSize(super.height);	
		}
		
		[Bindable(event="WidthScaled")]
		override public function set width(value:Number):void
		{
			super.width = Device.getScaledSize(value);
		}
		
		[Bindable(event="WidthScaled")]
		public function get definedWidth():Number
		{
			return Device.getUnScaledSize(super.width);	
		}
		
		[Bindable(event="LeftScaled")]
		override public function set left(value:Object):void
		{
			if(value != null && value is Number) {
				super.left = Device.getScaledSize(value as Number);	
			} else {
				super.left = value;
			}
		}
		
		[Bindable(event="LeftScaled")]
		public function get definedLeft():Object
		{
			if(super.left != null && super.left is Number) {
				return Device.getUnScaledSize(super.left as Number);
			}
			return super.left; 
		}
		
		[Bindable(event="TopScaled")]
		override public function set top(value:Object):void
		{
			if(value != null && value is Number) {
				super.top = Device.getScaledSize(value as Number);	
			} else {
				super.top = value;
			}
		}
		
		[Bindable(event="TopScaled")]
		public function get definedTop():Object
		{
			if(super.top != null && super.top is Number) {
				return Device.getUnScaledSize(super.top as Number);
			}
			return super.top; 
		}
		
		[Bindable(event="BottomScaled")]
		override public function set bottom(value:Object):void
		{
			if(value != null && value is Number) {
				super.bottom = Device.getScaledSize(value as Number);	
			} else {
				super.bottom = value;
			}
		}
		
		[Bindable(event="BottomScaled")]
		public function get definedBottom():Object
		{
			if(super.bottom != null && super.bottom is Number) {
				return Device.getUnScaledSize(super.bottom as Number);
			}
			return super.bottom; 
		}
		
		[Bindable(event="RightScaled")]
		override public function set right(value:Object):void
		{
			if(value != null && value is Number) {
				super.right = Device.getScaledSize(value as Number);	
			} else {
				super.right = value;
			}
		}
		
		[Bindable(event="RightScaled")]
		public function get definedRight():Object
		{
			if(super.right != null && super.right is Number) {
				return Device.getUnScaledSize(super.right as Number);
			}
			return super.right; 
		}
		
		[Bindable(event="XScaled")]
		override public function set x(value:Number):void
		{
			super.x = Device.getScaledSize(value);
		}
		
		[Bindable(event="XScaled")]
		public function get definedX():Number
		{
			return Device.getUnScaledSize(super.x);	
		}
		
		[Bindable(event="YScaled")]
		override public function set y(value:Number):void
		{
			super.y = Device.getScaledSize(value);
		}
		
		[Bindable(event="TScaled")]
		public function get definedY():Number
		{
			return Device.getUnScaledSize(super.y);	
		}
	}
}