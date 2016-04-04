package org.bigbluebutton.model.whiteboard {
	
	import mx.graphics.SolidColorStroke;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	import spark.primitives.Rect;
	
	public class RectangleAnnotation extends DrawingAnnotation {
		private var _thickness:Number = 1;
		
		private var _transparency:Boolean = false;
		
		private var _square:Boolean = false;
		
		private var _rectangle:Rect;
		
		public function RectangleAnnotation(type:String, anID:String, whiteboardID:String, status:String, color:Number, thickness:Number, transparency:Boolean, points:Array, square:Boolean) {
			super(type, anID, whiteboardID, status, color, points);
			_thickness = thickness;
			_transparency = transparency;
			_square = square;
		}
		
		public function get thickness():int {
			return _thickness;
		}
		
		public function get transparency():Boolean {
			return _transparency;
		}
		
		public function get square():Boolean {
			return _square;
		}
		
		override public function update(an:Annotation):void {
			if (an.anID == anID) {
				super.update(an);
				_thickness = RectangleAnnotation(an).thickness;
				_transparency = RectangleAnnotation(an).transparency;
				_points = RectangleAnnotation(an).points;
				_square = RectangleAnnotation(an).square;
			}
		}
		
		override public function draw(canvas:WhiteboardCanvas, zoom:Number):void {
			if (!_rectangle) {
				_rectangle = new Rect();
			}
			_rectangle.stroke = new SolidColorStroke(uint(color), thickness * zoom);
			var arrayEnd:Number = points.length;
			var startX:Number = denormalize(points[0], canvas.width);
			var startY:Number = denormalize(points[1], canvas.height);
			var width:Number = denormalize(points[arrayEnd - 2], canvas.width) - startX;
			var height:Number = denormalize(points[arrayEnd - 1], canvas.height) - startY;
			_rectangle.x = startX;
			_rectangle.y = startY;
			_rectangle.width = width;
			_rectangle.height = (square ? width : height);
			if (!canvas.containsElement(_rectangle)) {
				canvas.addElement(_rectangle);
			}
		}
		
		override public function remove(canvas:WhiteboardCanvas):void {
			if (canvas.containsElement(_rectangle)) {
				canvas.removeElement(_rectangle);
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
			
			//TODO: add additional properties
			ao["thickness"] = _thickness;
			ao["transparency"] = _transparency;
			ao["points"] = optimize(_points);
			ao["square"] = _square;
			
			
			return ao;
		}

	}
}
