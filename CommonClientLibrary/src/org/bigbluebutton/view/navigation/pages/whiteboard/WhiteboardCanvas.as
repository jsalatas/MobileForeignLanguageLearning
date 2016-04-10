package org.bigbluebutton.view.navigation.pages.whiteboard
{
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mx.core.FlexGlobals;
	
	import gr.ictpro.mall.client.components.Group;
	
	[Bindable]
	public class WhiteboardCanvas extends Group 
	{
		private var _resizeCallback:Function;
		
		private var _zoom:Number = 1.0;
		
		public function WhiteboardCanvas()
		{
			super();
		}

		public function set zoom(zoom:Number):void 
		{
			_zoom = zoom;	
		}
		
		public function get zoom():Number
		{
			return _zoom;
		}
		
		
		public function get resizeCallback():Function {
			return _resizeCallback;
		}
		
		public function set resizeCallback(callback:Function):void {
			_resizeCallback = callback;
		}
		
		public function moveCanvas(x:Number, y:Number, width:Number, height:Number, zoom:Number):void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			if (_resizeCallback != null)
				callLater(_resizeCallback, [zoom]);
		}
		
		public function dispose():void
		{
		}
	}
}