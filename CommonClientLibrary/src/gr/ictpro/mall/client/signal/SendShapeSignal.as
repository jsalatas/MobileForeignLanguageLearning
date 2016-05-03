package gr.ictpro.mall.client.signal
{
	import gr.ictpro.mall.client.view.components.bbb.WhiteboardView;
	
	import org.bigbluebutton.model.whiteboard.DrawingAnnotation;
	import org.bigbluebutton.view.navigation.pages.presentation.AnnotationControls;
	import org.osflash.signals.Signal;
	
	public class SendShapeSignal extends Signal
	{
		public function SendShapeSignal(...parameters)
		{
			super(AnnotationControls, DrawingAnnotation);
		}
	}
}