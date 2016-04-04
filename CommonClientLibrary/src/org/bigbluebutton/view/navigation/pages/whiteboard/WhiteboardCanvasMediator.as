package org.bigbluebutton.view.navigation.pages.whiteboard {
	
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.whiteboard.Annotation;
	import org.osmf.logging.Log;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class WhiteboardCanvasMediator extends SignalMediator {
		
		[Inject]
		public var view:WhiteboardCanvas;
		
		[Inject]
		public var userSession:UserSession;
		
		private var _zoom:Number = 1.0;
		
		override public function onRegister():void {
			userSession.presentationList.annotationHistorySignal.add(annotationHistoryHandler);
			userSession.presentationList.annotationUpdatedSignal.add(annotationUpdatedHandler);
			userSession.presentationList.annotationUndoSignal.add(annotationUndoHandler);
			userSession.presentationList.annotationClearSignal.add(annotationClearHandler);
			userSession.presentationList.slideChangeSignal.add(slideChangeHandler);
			view.resizeCallback = onWhiteboardResize;
		}
		
		private function annotationHistoryHandler():void {
			drawAllAnnotations();
		}
		
		private function annotationUpdatedHandler(annotation:Annotation):void {
			annotation.draw(view, _zoom);
		}
		
		private function annotationUndoHandler(annotation:Annotation):void {
			annotation.remove(view);
		}
		
		private function annotationClearHandler():void {
			removeAllAnnotations();
		}
		
		private function slideChangeHandler():void {
			removeAllAnnotations();
			drawAllAnnotations();
		}
		
		private function onWhiteboardResize(zoom:Number):void {
			trace("whiteboard zoom = " + zoom);
			_zoom = zoom;
			view.zoom = zoom;
			drawAllAnnotations();
		}
		
		private function drawAllAnnotations():void {
			var annotations:Array = userSession.presentationList.currentPresentation.getSlideAt(userSession.presentationList.currentPresentation.currentSlideNum).annotations;
			for (var i:int = 0; i < annotations.length; i++) {
				var an:Annotation = annotations[i] as Annotation;
				an.draw(view, _zoom);
			}
		}
		
		private function removeAllAnnotations():void {
			view.removeAllElements();
		}
		
		override public function onRemove():void {
			userSession.presentationList.annotationHistorySignal.remove(annotationHistoryHandler);
			userSession.presentationList.annotationUpdatedSignal.remove(annotationUpdatedHandler);
			userSession.presentationList.annotationUndoSignal.remove(annotationUndoHandler);
			userSession.presentationList.annotationClearSignal.remove(annotationClearHandler);
			userSession.presentationList.slideChangeSignal.remove(slideChangeHandler);
			super.onRemove();
			view.dispose();
			view = null;
		}
	}
}
