package org.bigbluebutton.core {
	
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.whiteboard.Annotation;
	
	public class WhiteboardMessageSender {
		private static var LOG:String = "WhiteboardMessageSender - ";
		
		private var userSession:UserSession;

		private var defaultSuccessResponse:Function = function(result:String):void {trace(result);};
		
		private var defaultFailureResponse:Function = function(status:String):void {trace(status);};
		

		public function WhiteboardMessageSender(userSession:UserSession) {
			this.userSession = userSession;
		}
		
		public function changePage(pageNum:Number):void {
			//			LogUtil.debug("Sending [whiteboard.setActivePage] to server.");
		/*
		   var message:Object = new Object();
		   message["pageNum"] = pageNum;
		
		   var _nc:ConnectionManager = BBB.initConnectionManager();
		   _nc.sendMessage("whiteboard.setActivePage",
		   function(result:String):void { // On successful result
		   LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		   LogUtil.error(status);
		   },
		   message
		   );
		 */
		}
		
		/*
		   public function modifyEnabled(e:WhiteboardPresenterEvent):void {
		   //			LogUtil.debug("Sending [whiteboard.enableWhiteboard] to server.");
		   var message:Object = new Object();
		   message["enabled"] = e.enabled;
		
		   var _nc:ConnectionManager = BBB.initConnectionManager();
		   _nc.sendMessage("whiteboard.toggleGrid",
		   function(result:String):void { // On successful result
		   LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		   LogUtil.error(status);
		   },
		   message
		   );
		   }
		 */
		/*
		   public function toggleGrid():void{
		   //			LogUtil.debug("Sending [whiteboard.toggleGrid] to server.");
		   var _nc:ConnectionManager = BBB.initConnectionManager();
		   _nc.sendMessage("whiteboard.toggleGrid",
		   function(result:String):void { // On successful result
		   LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		   LogUtil.error(status);
		   }
		   );
		   }
		 */
		public function undoGraphic(whiteboardID:String):void {
			var msg:Object = new Object();
			msg["whiteboardId"] = whiteboardID;
			userSession.mainConnection.sendMessage("whiteboard.undo", defaultSuccessResponse, defaultFailureResponse, msg);
		}
		
		public function clearBoard(whiteboardID:String):void {
			var msg:Object = new Object();
			msg["whiteboardId"] = whiteboardID;
			userSession.mainConnection.sendMessage("whiteboard.clear", defaultSuccessResponse, defaultFailureResponse, msg);
		}
		
		public function requestAnnotationHistory(whiteboardID:String):void {
			trace("Sending [whiteboard.requestAnnotationHistory] to server.");
			var msg:Object = new Object();
			msg["whiteboardId"] = whiteboardID;
			userSession.mainConnection.sendMessage("whiteboard.requestAnnotationHistory",defaultSuccessResponse,defaultFailureResponse,msg);
		}
		
		public function sendText():void {
			//			LogUtil.debug("Sending [whiteboard.sendAnnotation] (TEXT) to server.");
		/*
		   var _nc:ConnectionManager = BBB.initConnectionManager();
		   _nc.sendMessage("whiteboard.sendAnnotation",
		   function(result:String):void { // On successful result
		   //                    LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		   LogUtil.error(status);
		   },
		   e.annotation.annotation
		   );
		 */
		}
		
		public function sendShape(a:Annotation):void {
			//var msg:Object = new Object();
			var msg:Object = a.annotation;
			
			userSession.mainConnection.sendMessage("whiteboard.sendAnnotation", defaultSuccessResponse, defaultFailureResponse, msg);
		}
		
		/*
		   public function checkIsWhiteboardOn():void {
		   //			LogUtil.debug("Sending [whiteboard.isWhiteboardEnabled] to server.");
		   var _nc:ConnectionManager = BBB.initConnectionManager();
		   _nc.sendMessage("whiteboard.isWhiteboardEnabled",
		   function(result:String):void { // On successful result
		   LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		   LogUtil.error(status);
		   }
		   );
		   }
		 */
		public function setActivePresentation():void {
			//			LogUtil.debug("Sending [whiteboard.isWhiteboardEnabled] to server.");
		/*
		   var message:Object = new Object();
		   message["presentationID"] = e.presentationName;
		   message["numberOfSlides"] = e.numberOfPages;
		
		   var _nc:ConnectionManager = BBB.initConnectionManager();
		   _nc.sendMessage("whiteboard.setActivePresentation",
		   function(result:String):void { // On successful result
		   LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		   LogUtil.error(status);
		   },
		   message
		   );
		 */
		}
	}
}
