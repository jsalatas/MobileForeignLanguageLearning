package org.bigbluebutton.model.whiteboard {
	
	import mx.graphics.SolidColorStroke;
	
	import spark.primitives.Ellipse;
	
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	
	public class EllipseAnnotation extends DrawingAnnotation {
		private var _thickness:Number = 1;
		
		private var _transparency:Boolean = false;
		
		private var _circle:Boolean = false;
		
		private var _ellipse:Ellipse;
		
		public function EllipseAnnotation(type:String, anID:String, whiteboardID:String, status:String, color:Number, thickness:Number, transparency:Boolean, points:Array, circle:Boolean) {
			super(type, anID, whiteboardID, status, color, points);
			_thickness = thickness;
			_transparency = transparency;
			_circle = circle;
		}
		
		public function get thickness():Number {
			return _thickness;
		}
		
		public function get transparency():Boolean {
			return _transparency;
		}
		
		public function get circle():Boolean {
			return _circle;
		}
		
		override public function update(an:Annotation):void {
			if (an.anID == anID) {
				super.update(an);
				_thickness = EllipseAnnotation(an).thickness;
				_transparency = EllipseAnnotation(an).transparency;
				_points = EllipseAnnotation(an).points;
				_circle = EllipseAnnotation(an).circle;
			}
		}
		
		override public function draw(canvas:WhiteboardCanvas, zoom:Number):void {
			if (!_ellipse) {
				_ellipse = new Ellipse();
			}
			_ellipse.stroke = new SolidColorStroke(color, thickness * zoom);
			var arrayEnd:Number = points.length;
			var startX:Number = denormalize(points[0], canvas.width);
			var startY:Number = denormalize(points[1], canvas.height);
			var width:Number = denormalize(points[arrayEnd - 2], canvas.width) - startX;
			var height:Number = denormalize(points[arrayEnd - 1], canvas.height) - startY;
			_ellipse.x = startX;
			_ellipse.y = startY;
			_ellipse.width = width;
			_ellipse.height = (circle ? width : height);
			if (!canvas.containsElement(_ellipse)) {
				canvas.addElement(_ellipse);
			}
		}
		
		override public function remove(canvas:WhiteboardCanvas):void {
			if (canvas.containsElement(_ellipse)) {
				canvas.removeElement(_ellipse);
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
			ao["circle"] = false;
			
			return ao;
		}
	}
}
