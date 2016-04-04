package org.bigbluebutton.model.whiteboard {
	
	import mx.graphics.SolidColorStroke;
	import org.bigbluebutton.util.Triangle;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	
	public class TriangleAnnotation extends DrawingAnnotation {
		private var _thickness:Number = 1;
		
		private var _transparency:Boolean = false;
		
		private var _triangle:Triangle;
		
		public function TriangleAnnotation(type:String, anID:String, whiteboardID:String, status:String, color:Number, thickness:Number, transparency:Boolean, points:Array) {
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
				_thickness = TriangleAnnotation(an).thickness;
				_transparency = TriangleAnnotation(an).transparency;
				_points = TriangleAnnotation(an).points;
			}
		}
		
		override public function draw(canvas:WhiteboardCanvas, zoom:Number):void {
			if (!_triangle) {
				_triangle = new Triangle();
			}
			_triangle.stroke = new SolidColorStroke(uint(color), thickness * zoom);
			var arrayEnd:Number = points.length;
			var startX:Number = denormalize(points[0], canvas.width);
			var startY:Number = denormalize(points[1], canvas.height);
			var triangleWidth:Number = denormalize(points[arrayEnd - 2], canvas.width) - startX;
			var triangleHeight:Number = denormalize(points[arrayEnd - 1], canvas.height) - startY;
			_triangle.x = startX;
			_triangle.y = startY;
			_triangle.width = triangleWidth;
			_triangle.height = triangleHeight;
			if (!canvas.containsElement(_triangle)) {
				canvas.addElement(_triangle);
			}
		}
		
		override public function remove(canvas:WhiteboardCanvas):void {
			if (canvas.containsElement(_triangle)) {
				canvas.removeElement(_triangle);
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
