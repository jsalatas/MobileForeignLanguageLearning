package gr.ictpro.mall.client.components
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LongPressEvent extends MouseEvent
	{
		public static const LONG_PRESS:String = "longpress";
		public var item:Object; 
		
		public function LongPressEvent(type:String, item:Object, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0, commandKey:Boolean=false, controlKey:Boolean=false, clickCount:int=0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, controlKey, clickCount);
			this.item = item;
		}
		
		override public function clone():Event
		{
			return new LongPressEvent(type, item, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, controlKey, clickCount);
		}
		
		
		
	}
	
}