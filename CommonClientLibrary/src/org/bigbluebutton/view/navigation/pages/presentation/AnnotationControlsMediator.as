package org.bigbluebutton.view.navigation.pages.presentation
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.components.ToggleButton;
	
	import org.bigbluebutton.core.PresentationService;
	import org.bigbluebutton.core.WhiteboardService;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.whiteboard.Annotation;
	import org.bigbluebutton.model.whiteboard.AnnotationStatus;
	import org.bigbluebutton.model.whiteboard.AnnotationType;
	import org.bigbluebutton.model.whiteboard.DrawingAnnotation;
	import org.bigbluebutton.model.whiteboard.EllipseAnnotation;
	import org.bigbluebutton.model.whiteboard.LineAnnotation;
	import org.bigbluebutton.model.whiteboard.PencilAnnotation;
	import org.bigbluebutton.model.whiteboard.RectangleAnnotation;
	import org.bigbluebutton.model.whiteboard.TriangleAnnotation;
	import org.bigbluebutton.view.navigation.pages.whiteboard.AnnotationIDGenerator;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.IDrawingButton;
	import org.osflash.signals.MonoSignal;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class AnnotationControlsMediator extends SignalMediator
	{
		[Inject]
		public var view:AnnotationControls;
		
		[Inject]
		public var whiteboardService:WhiteboardService;

		[Inject]
		public var presentationService:PresentationService;
		

		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var annotationIDGenerator:AnnotationIDGenerator;
		
		private var isDrawing:Boolean = false;
		private var isMoving:Boolean = false;
		
		private var currentAnnotation:DrawingAnnotation = null;

		private var movePreviousPoint:Point = null;
		
		private var moveCompleted:Boolean= true;

		private var whiteboardID:String; 
		private var slideNum:int;
		
		override public function onRegister():void {
			addToSignal(view.undoSignal, undoHandler);	
			addToSignal(view.clearSignal, clearHandler);
			addToSignal(userSession.presentationList.currentPresentation.slideChangeSignal, presentationChangeHandler);
			addToSignal(userSession.presentationList.viewedRegionChangeSignal, viewedRegionChangeHandler);

			view.viewport.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);			

			presentationChangeHandler();

		}
		
		private function viewedRegionChangeHandler(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			moveCompleted = true;
//			movePreviousPoint = new Point(view.slide.mouseX, view.slide.mouseY);
		}

		override public function onRemove():void
		{
			view.viewport.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);			
			cancelDrawingTool();
		}

		private function presentationChangeHandler():void {
			whiteboardID= userSession.presentationList.currentPresentation.id;
			slideNum = userSession.presentationList.currentPresentation.currentSlideNum+1;
		}

		private function cancelDrawingTool():void
		{
			currentAnnotation = null;
			movePreviousPoint = null;
			moveCompleted = true;
			
			if(isDrawing) {
				view.viewport.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				view.viewport.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				view.viewport.removeEventListener(MouseEvent.MOUSE_OUT, mouseUp);
				isDrawing = false;	
			}
			if(isMoving) {
				view.viewport.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				view.viewport.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				view.viewport.removeEventListener(MouseEvent.MOUSE_OUT, mouseUp);
				isMoving = false;	
			}
		}

		private function mouseMove(e:MouseEvent):void
		{
			if((isDrawing && currentAnnotation == null) || (isMoving && movePreviousPoint == null)) {
				return;
			}
			if(isDrawing) {
				currentAnnotation.status = AnnotationStatus.DRAW_UPDATE;
				var xPercent:Number = view.slide.mouseX / view.slide.width *100;
				var yPercent:Number = view.slide.mouseY / view.slide.height *100;
				
				currentAnnotation.points.push(xPercent);
				currentAnnotation.points.push(yPercent);
				whiteboardService.sendShape(currentAnnotation);
			} else if(isMoving && moveCompleted) {
				var xoffset:Number = view.slide.x*100/(view.slide.width*2);
				var yoffset:Number = view.slide.y*100/(view.slide.height*2);

				trace(">>>>>>> before: " + xoffset + " " + yoffset);
				var moveEndingPoint:Point = new Point(view.slide.mouseX, view.slide.mouseY);
				var diffX:Number=(moveEndingPoint.x - movePreviousPoint.x)*100/(view.slide.width*2);
				var diffY:Number=(moveEndingPoint.y - movePreviousPoint.y)*100/(view.slide.height*2);
				
				trace(">>>>>>> diff: " + diffX + " " + diffY);

				movePreviousPoint.x = moveEndingPoint.x;
				movePreviousPoint.y = moveEndingPoint.y;
					
				xoffset+=diffX;
				yoffset+=diffY;
				if(xoffset >0 ) {
					xoffset = 0;
				}
				if(yoffset >0 ) {
					yoffset = 0;
				}
				
				var newX:Number = xoffset*(view.slide.width*2)/100;
				var newY:Number = yoffset*(view.slide.height*2)/100;
				
				if ((view.slide.width + newX) < view.viewport.width) {
					// Don't let the right edge move inside the view.
					newX = (view.viewport.width - view.slide.width) / 2;
					xoffset = newX*100/(view.slide.width);
				} 

				if ((view.slide.height + newY) < view.viewport.height) {
					// Don't let the right edge move inside the view.
					newY = (view.viewport.height - view.slide.height) / 2;
					yoffset = newY*100/(view.slide.height);
				} 
				

				trace(">>>>>>> after: " + xoffset + " " + yoffset);
				moveCompleted = false;
				presentationService.move(xoffset, yoffset, 100/view.whiteboard.zoom, 100/view.whiteboard.zoom);
			}
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			if(view.selectedTool != null && view.selectedTool is IDrawingButton) {
				var type:String = IDrawingButton(view.selectedTool).tool;
				isDrawing = true;
				view.viewport.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);			
				view.viewport.addEventListener(MouseEvent.MOUSE_UP, mouseUp);			
				view.viewport.addEventListener(MouseEvent.MOUSE_OUT, mouseUp);
				
				var points:Array = new Array();
				var xPercent:Number = view.slide.mouseX / view.slide.width *100;
				var yPercent:Number = view.slide.mouseY / view.slide.height *100;
				points.push(xPercent);
				points.push(yPercent);
				currentAnnotation = createAnnotation(type, points);
				
				whiteboardService.sendShape(currentAnnotation);
			} else if(view.selectedTool == view.panZoomButton) {
				isMoving = true;
				movePreviousPoint = new Point(view.slide.mouseX, view.slide.mouseY);
				view.viewport.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);			
				view.viewport.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				view.viewport.addEventListener(MouseEvent.MOUSE_OUT, mouseUp);

			}
		}
		
		private function createAnnotation(type:String, points:Array):DrawingAnnotation {
			var an:DrawingAnnotation = null;
			switch(type)
			{
				case AnnotationType.RECTANGLE:
				{
					an = new RectangleAnnotation(type, annotationIDGenerator.generateID(), getWhiteboardId(), AnnotationStatus.DRAW_START, view.color, view.thickness, false, points, false);	
					break;
				}
				case AnnotationType.ELLIPSE:
				{
					an = new EllipseAnnotation(type, annotationIDGenerator.generateID(), getWhiteboardId(), AnnotationStatus.DRAW_START, view.color, view.thickness, false, points, false);	
					break;
				}
				case AnnotationType.TRIANGLE:
				{
					an = new TriangleAnnotation(type, annotationIDGenerator.generateID(), getWhiteboardId(), AnnotationStatus.DRAW_START, view.color, view.thickness, false, points);	
					break;
				}
				case AnnotationType.LINE:
				{
					an = new LineAnnotation(type, annotationIDGenerator.generateID(), getWhiteboardId(), AnnotationStatus.DRAW_START, view.color, view.thickness, false, points);	
					break;
				}
				case AnnotationType.PENCIL:
				{
					an = new PencilAnnotation(type, annotationIDGenerator.generateID(), getWhiteboardId(), AnnotationStatus.DRAW_START, view.color, view.thickness, false, points);	
					break;
				}
			}

			return an;
		}

		private function mouseUp(e:MouseEvent):void
		{
			if((isDrawing && currentAnnotation == null) ||isMoving) {
				cancelDrawingTool();
				return;
			}
			if(isDrawing) {
				currentAnnotation.status = AnnotationStatus.DRAW_END;
				var xPercent:Number = view.slide.mouseX / view.slide.width *100;
				var yPercent:Number = view.slide.mouseY / view.slide.height *100;
	
				currentAnnotation.points.push(xPercent);
				currentAnnotation.points.push(yPercent);
				whiteboardService.sendShape(currentAnnotation);
			}
			cancelDrawingTool();
		}
		
		private function getWhiteboardId():String
		{
			trace(">>>>>>>>>>>> whiteboard id: " + whiteboardID + "/" + slideNum);
			return whiteboardID + "/" + slideNum;
		}

		private function undoHandler():void
		{
			whiteboardService.undoGraphic(whiteboardID, slideNum);
		}
		
		private function clearHandler():void
		{
			whiteboardService.clearBoard(whiteboardID, slideNum);
		}

		
	}
}