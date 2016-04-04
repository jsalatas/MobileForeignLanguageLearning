package org.bigbluebutton.model.whiteboard
{
	public class DrawingAnnotation extends Annotation
	{
		protected var _points:Array = [];
		public function DrawingAnnotation(type:String, anID:String, whiteboardID:String, status:String, color:Number, points:Array)
		{
			super(type, anID, whiteboardID, status, color);
			
			_points = points;
		}
		
		public function get points():Array {
			return _points;
		}
		

	}
}