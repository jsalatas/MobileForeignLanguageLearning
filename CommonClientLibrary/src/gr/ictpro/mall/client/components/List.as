package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.InteractionMode;
	import mx.events.TouchInteractionEvent;
	
	import spark.components.List;
	
	public class List extends spark.components.List
	{
		public function List()
		{
			super();
			super.setStyle("skinClass", Device.listSkin);
			if(Device.isAndroid) {
				super.setStyle("interactionMode", InteractionMode.TOUCH);
			} else {
				super.setStyle("interactionMode", InteractionMode.MOUSE);
			}
			
			this.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, onInteractionStart);
			

		}
		
		protected function onInteractionStart(event:TouchInteractionEvent):void
		{
			trace("onInteractionStart");
			// set this to null when the scroll is starting again to avoid dispatch on item_mouseUpHandler
			
		}
		override public function set height(value:Number):void
		{
			super.height = Device.getScaledSize(value);
		}
		
		override public function set width(value:Number):void
		{
			super.width = Device.getScaledSize(value);
		}

	}
}