package org.bigbluebutton.core {
	
	import org.bigbluebutton.core.WhiteboardMessageReceiver;
	import org.bigbluebutton.core.WhiteboardMessageSender;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.whiteboard.Annotation;
	
	public class WhiteboardService {
		
		[Inject]
		public var userSession:UserSession;
		
		private var whiteboardMessageSender:WhiteboardMessageSender;
		
		private var whiteboardMessageReceiver:WhiteboardMessageReceiver;
		
		public function WhiteboardService() {
		}
		
		public function setupMessageSenderReceiver():void {
			whiteboardMessageSender = new WhiteboardMessageSender(userSession);
			whiteboardMessageReceiver = new WhiteboardMessageReceiver(userSession);
			userSession.mainConnection.addMessageListener(whiteboardMessageReceiver as IMessageListener);
		}
		
		public function getAnnotationHistory(presentationID:String, pageNumber:int):void {
			whiteboardMessageSender.requestAnnotationHistory(presentationID + "/" + pageNumber);
		}
		
		public function changePage(pageNum:Number):void {
			pageNum += 1;
			//if (isPresenter) {
			whiteboardMessageSender.changePage(pageNum);
			//}
		}
		
		public function undoGraphic(whiteboardID:String, pageNumber:int):void {
			whiteboardMessageSender.undoGraphic(whiteboardID+ "/" + pageNumber);
		}
		
		public function clearBoard(whiteboardID:String, pageNumber:int):void {
			whiteboardMessageSender.clearBoard(whiteboardID+ "/" + pageNumber);
		}
		
		public function sendText():void {
			whiteboardMessageSender.sendText();
		}
		
		public function sendShape(a:Annotation):void {
			whiteboardMessageSender.sendShape(a);
		}
		
		public function setActivePresentation():void {
			//if (isPresenter) {
			whiteboardMessageSender.setActivePresentation();
			//}
		}
	}
}
