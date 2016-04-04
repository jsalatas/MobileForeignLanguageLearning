package org.bigbluebutton.core {
	
	import flash.net.NetConnection;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class ChatMessageSender {
		public var userSession:UserSession;
		
		private var successSendMessageSignal:ISignal;
		
		private var failureSendingMessageSignal:ISignal;
		
		public function ChatMessageSender(userSession:UserSession, successSendMessageSignal:ISignal, failureSendingMessageSignal:ISignal) {
			this.userSession = userSession;
			this.successSendMessageSignal = successSendMessageSignal;
			this.failureSendingMessageSignal = failureSendingMessageSignal;
		}
		
		public function getPublicChatMessages():void {
			trace("Sending [chat.getPublicMessages] to server.");
			userSession.mainConnection.sendMessage("chat.sendPublicChatHistory",
												   function(result:String):void { // On successful result
													   publicChatMessagesOnSucessSignal.dispatch(result);
												   },
												   function(status:String):void { // status - On error occurred
													   publicChatMessagesOnFailureSignal.dispatch(status);
												   }
												   );
		}
		
		public function sendPublicMessage(message:ChatMessageVO):void {
			trace("Sending [chat.sendPublicMessage] to server. [" + message.message + "]");
			userSession.mainConnection.sendMessage("chat.sendPublicMessage",
												   function(result:String):void { // On successful result
													   successSendMessageSignal.dispatch(result);
												   },
												   function(status:String):void { // status - On error occurred
													   failureSendingMessageSignal.dispatch(status);
												   },
												   message.toObj()
												   );
		}
		
		public function sendPrivateMessage(message:ChatMessageVO):void {
			trace("Sending [chat.sendPrivateMessage] to server.");
			trace("Sending fromUserID [" + message.fromUserID + "] to toUserID [" + message.toUserID + "]");
			userSession.mainConnection.sendMessage("chat.sendPrivateMessage",
												   function(result:String):void { // On successful result
													   successSendMessageSignal.dispatch(result);
												   },
												   function(status:String):void { // status - On error occurred
													   failureSendingMessageSignal.dispatch(status);
												   },
												   message.toObj()
												   );
		}
		
		private var _publicChatMessagesOnSucessSignal:Signal = new Signal();
		
		private var _publicChatMessagesOnFailureSignal:Signal = new Signal();
		
		public function get publicChatMessagesOnSucessSignal():Signal {
			return _publicChatMessagesOnSucessSignal;
		}
		
		public function get publicChatMessagesOnFailureSignal():Signal {
			return _publicChatMessagesOnFailureSignal;
		}
	}
}
