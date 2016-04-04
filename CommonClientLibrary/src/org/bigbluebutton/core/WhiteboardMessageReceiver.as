package org.bigbluebutton.core {
	
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.whiteboard.Annotation;
	import org.bigbluebutton.util.AnnotationUtil;
	
	public class WhiteboardMessageReceiver implements IMessageListener {
		private static var LOG:String = "WhiteboardMessageReciever - ";
		
		private var _userSession:UserSession;
		
		public function WhiteboardMessageReceiver(userSession:UserSession) {
			_userSession = userSession;
		}
		
		public function onMessage(messageName:String, message:Object):void {
			// LogUtil.debug("WB: received message " + messageName);
			switch (messageName) {
				case "WhiteboardRequestAnnotationHistoryReply":
					handleRequestAnnotationHistoryReply(message);
					break;
				case "WhiteboardIsWhiteboardEnabledReply":
					handleIsWhiteboardEnabledReply(message);
					break;
				case "WhiteboardEnableWhiteboardCommand":
					handleEnableWhiteboardCommand(message);
					break;
				case "WhiteboardNewAnnotationCommand":
					handleNewAnnotationCommand(message);
					break;
				case "WhiteboardClearCommand":
					handleClearCommand(message);
					break;
				case "WhiteboardUndoCommand":
					handleUndoCommand(message);
					break;
				case "WhiteboardChangePageCommand":
					handleChangePageCommand(message);
					break;
				case "WhiteboardChangePresentationCommand":
					handleChangePresentationCommand(message);
					break;
				default:
					//          LogUtil.warn("Cannot handle message [" + messageName + "]");
			}
		}
		
		private function handleChangePresentationCommand(message:Object):void {
			//			whiteboardModel.changePresentation(message.presentationID, message.numberOfPages);
		}
		
		private function handleChangePageCommand(message:Object):void {
			//			whiteboardModel.changePage(message.pageNum, message.numAnnotations);
		}
		
		private function handleClearCommand(message:Object):void {
			_userSession.presentationList.clearAnnotations();
		}
		
		private function handleUndoCommand(message:Object):void {
			_userSession.presentationList.undoAnnotation();
		}
		
		private function handleEnableWhiteboardCommand(message:Object):void {
			//whiteboardModel.enable(message.enabled);
		}
		
		private function handleNewAnnotationCommand(message:Object):void {
			trace(LOG + "handleNewAnnotationCommand received");
			message = JSON.parse(message.msg).shape.shape;
			AnnotationUtil.createAnnotation(message);
			var tempAnnotation:Annotation = AnnotationUtil.createAnnotation(message);
			if (tempAnnotation != null) {
				_userSession.presentationList.addAnnotation(tempAnnotation);
			} else {
				trace(LOG + "handleAnnotationHistoryReply: Annotation with id: " + message.id + " is invalid");
			}
		}
		
		private function handleIsWhiteboardEnabledReply(message:Object):void {
			//LogUtil.debug("Whiteboard Enabled? " + message.enabled);
		}
		
		private function handleRequestAnnotationHistoryReply(message:Object):void {
			var msg:Object = JSON.parse(message.msg);
			if (msg.count == 0) {
				trace(LOG + "handleRequestAnnotationHistoryReply: No annotations.");
			} else {
				trace(LOG + "handleRequestAnnotationHistoryReply: Number of annotations in history = " + msg.count);
				var annotations:Array = msg.annotations as Array;
				var tempAnnotations:Array = new Array();
				for (var i:int = 0; i < msg.count; i++) {
					var an:Object = annotations[i] as Object;
					var tempAnnotation:Annotation = AnnotationUtil.createAnnotation(an.shapes);
					if (tempAnnotation != null) {
						tempAnnotations.push(tempAnnotation);
					} else {
						trace(LOG + "handleAnnotationHistoryReply: Annotation with id: " + an.id + " is invalid");
					}
				}
				if (tempAnnotations.length > 0) {
					_userSession.presentationList.addAnnotationHistory(msg.whiteboardId, tempAnnotations);
				}
			}
		}
	}
}
