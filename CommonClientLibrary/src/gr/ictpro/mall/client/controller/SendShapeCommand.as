package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.view.components.bbb.WhiteboardView;
	
	import org.bigbluebutton.core.WhiteboardService;
	import org.bigbluebutton.model.whiteboard.AnnotationStatus;
	import org.bigbluebutton.model.whiteboard.AnnotationType;
	import org.bigbluebutton.model.whiteboard.DrawingAnnotation;
	import org.bigbluebutton.view.navigation.pages.presentation.AnnotationControls;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class SendShapeCommand extends SignalCommand
	{
		[Inject]
		public var view:AnnotationControls;
		
		[Inject]
		public var currentAnnotation:DrawingAnnotation;
		
		[Inject]
		public var whiteboardService:WhiteboardService;
		
		
		override public function execute():void
		{
			currentAnnotation.status = AnnotationStatus.DRAW_UPDATE;
			var xPercent:Number = view.slide.mouseX / view.slide.width *100;
			var yPercent:Number = view.slide.mouseY / view.slide.height *100;
			
			currentAnnotation.points.push(xPercent);
			currentAnnotation.points.push(yPercent);
			if(currentAnnotation.type == AnnotationType.PENCIL || currentAnnotation.points.length>=20) {
				whiteboardService.sendShape(currentAnnotation);
			}
		}
		
	}
}