package org.bigbluebutton.model.whiteboard {
	
	import mx.graphics.SolidColorStroke;
	
	import spark.primitives.Line;
	
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	
	public class LineAnnotation extends DrawingAnnotation {
		private var _thickness:int = 1;
		
		private var _transparency:Boolean = false;
		
		private var _line:Line;
		
		public function LineAnnotation(type:String, anID:String, whiteboardID:String, status:String, color:Number, thickness:Number, transparency:Boolean, points:Array) {
			super(type, anID, whiteboardID, status, color, points);
			_thickness = thickness;
			_transparency = transparency;
		}
		
		public function get thickness():int {
			return _thickness;
		}
		
		public function get transparency():Boolean {
			return _transparency;
		}
		
		override public function update(an:Annotation):void {
			if (an.anID == anID) {
				super.update(an);
				_thickness = LineAnnotation(an).thickness;
				_transparency = LineAnnotation(an).transparency;
				_points = LineAnnotation(an).points;
			}
		}
		
		override public function draw(canvas:WhiteboardCanvas, zoom:Number):void {
			if (!_line) {
				_line = new Line();
			}
			_line.stroke = new SolidColorStroke(uint(color), thickness * zoom);
			var arrayEnd:Number = points.length;
			var startX:Number = denormalize(points[0], canvas.width);
			var startY:Number = denormalize(points[1], canvas.height);
			var endX:Number = denormalize(points[arrayEnd - 2], canvas.width);
			var endY:Number = denormalize(points[arrayEnd - 1], canvas.height);
			_line.xFrom = startX;
			_line.yFrom = startY;
			_line.xTo = endX;
			_line.yTo = endY;
			if (!canvas.containsElement(_line)) {
				canvas.addElement(_line);
			}
		}
		
		override public function remove(canvas:WhiteboardCanvas):void {
			if (canvas.containsElement(_line)) {
				canvas.removeElement(_line);
			}
		}

		private function optimize(segment:Array):Array {
			var x1:Number = segment[0];
			var y1:Number = segment[1];
			var x2:Number = segment[segment.length - 2];
			var y2:Number = segment[segment.length - 1];
			
			
			var shape:Array = new Array();
			shape.push(x1);
			shape.push(y1);
			shape.push(x2);
			shape.push(y2);
			
			return shape;
		}

		override public function get annotation():Object
		{
			var ao:Object = super.annotation;
			
			ao["thickness"] = _thickness;
			ao["transparency"] = _transparency;
			ao["points"] = optimize(_points);
			
			return ao;
		}

	}
}
