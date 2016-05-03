package org.bigbluebutton.model.whiteboard {
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	
	public class Annotation  {
		private var _type:String = "undefined";
		
		private var _anID:String = "undefined";
		
		private var _whiteboardID:String = "undefined";
		
		private var _status:String = AnnotationStatus.DRAW_START;
		
		private var _color:Number;
		
		public function Annotation(type:String, anID:String, whiteboardID:String, status:String, color:Number) {
			_type = type;
			_anID = anID;
			_whiteboardID = whiteboardID;
			_status = status;
			_color = color;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get anID():String {
			return _anID;
		}
		
		public function get whiteboardID():String {
			return _whiteboardID;
		}
		
		public function get status():String {
			return _status;
		}

		public function set status(status:String):void {
			_status = status;
		}

		public function get color():Number {
			return _color;
		}
		
		public function update(an:Annotation):void {
			if (an.anID == this.anID) {
				_color = an.color;
				_status = an.status;
			}
		}
		
		public function denormalize(val:Number, side:Number):Number {
			return (val * side) / 100.0;
		}
		
		public function normalize(val:Number, side:Number):Number {
			return (val * 100.0) / side;
		}
		
		public function draw(canvas:WhiteboardCanvas, zoom:Number):void {
		}
		
		public function remove(canvas:WhiteboardCanvas):void {
		}
		
		public function get annotation():Object
		{
			var ao:Object = new Object();
			ao["type"] = _type;
			ao["id"] = _anID;
			ao["whiteboardId"] = _whiteboardID;
			ao["status"] = _status;
			
			ao["color"] = _color;

			return ao;
		}
	}
}
