package org.bigbluebutton.model.whiteboard {
	
	import mx.graphics.SolidColorStroke;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	import spark.primitives.Path;
	
	public class PencilAnnotation extends DrawingAnnotation {
		private var _thickness:int = 1;
		
		private var _transparency:Boolean = false;
		
		private var _path:Path;
		
		public function PencilAnnotation(type:String, anID:String, whiteboardID:String, status:String, color:Number, thickness:Number, transparency:Boolean, points:Array) {
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
				_thickness = PencilAnnotation(an).thickness;
				_transparency = PencilAnnotation(an).transparency;
				_points = PencilAnnotation(an).points;
			}
		}
		
		override public function draw(canvas:WhiteboardCanvas, zoom:Number):void {
			if (!_path) {
				_path = new Path();
			}
			_path.stroke = new SolidColorStroke(uint(color), thickness * zoom);
			var graphicsCommands:String = "";
			graphicsCommands += "M ";
			graphicsCommands += denormalize(points[0], canvas.width) + " " + denormalize(points[1], canvas.height) + "\n";
			for (var i:int = 2; i < points.length; i += 2) {
				graphicsCommands += "L ";
				graphicsCommands += denormalize(points[i], canvas.width) + " " + denormalize(points[i + 1], canvas.height) + "\n";
			}
			_path.data = graphicsCommands;
			if (!canvas.containsElement(_path)) {
				canvas.addElement(_path);
			}
		}
		
		override public function remove(canvas:WhiteboardCanvas):void {
			if (canvas.containsElement(_path)) {
				canvas.removeElement(_path);
			}
		}
		
		override public function get annotation():Object
		{
			var ao:Object = super.annotation;
			
			ao["thickness"] = _thickness;
			ao["transparency"] = _transparency;
			ao["points"] = _points;
			
			return ao;
		}

	}
}
