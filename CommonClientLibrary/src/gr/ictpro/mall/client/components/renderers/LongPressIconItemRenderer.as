package gr.ictpro.mall.client.components.renderers
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	import gr.ictpro.mall.client.components.List;
	import gr.ictpro.mall.client.components.LongPressEvent;
	
	public class LongPressIconItemRenderer extends IconItemRenderer
	{
		private var timer:Timer = new Timer(500);
		
		private var inLongPress:Boolean = false;
		
		public function LongPressIconItemRenderer()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			inLongPress = false;
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			timer.addEventListener(TimerEvent.TIMER, timerCompleteHandler); 
			timer.start();
			e.stopImmediatePropagation();
			e.preventDefault();
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, timerCompleteHandler); 
			e.stopImmediatePropagation();
			e.preventDefault();
			if(inLongPress) {
				inLongPress = false;
				var event:LongPressEvent= new LongPressEvent(LongPressEvent.LONG_PRESS, this.data, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta, e.commandKey, e.controlKey, e.clickCount);
				dispatchEvent(event);
			} else {
				var list:List = owner as List;
				for (var i:int = 0; i < list.dataGroup.numElements; i++) {
					if(list.dataProvider.getItemAt(i) == this.data) {
						toggleSelected(i);
						break;
					}
				}
			}
		}
		
		private function toggleSelected(index:Number):void {
			var list:List = owner as List;
			var indexPos:int = list.selectedIndices.indexOf(index);
			if(indexPos >= 0) {
				list.selectedIndices.removeAt(indexPos);
				this.selected = false;
			} else {
				list.selectedIndices.push(index);
				this.selected = true;
			}
		}
		
		private function timerCompleteHandler(e:TimerEvent):void
		{
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, timerCompleteHandler); 
			inLongPress = true;
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);

			mouseUp(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		
		
	}
}