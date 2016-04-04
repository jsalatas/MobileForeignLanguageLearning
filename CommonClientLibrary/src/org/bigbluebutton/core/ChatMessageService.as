package org.bigbluebutton.core {
	
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class ChatMessageService {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var chatMessagesSession:ChatMessagesSession;
		
		public var chatMessageSender:ChatMessageSender;
		
		public var chatMessageReceiver:ChatMessageReceiver;
		
		private var _sendMessageOnSuccessSignal:ISignal = new Signal();
		
		private var _sendMessageOnFailureSignal:ISignal = new Signal();
		
		public function get sendMessageOnSuccessSignal():ISignal {
			return _sendMessageOnSuccessSignal;
		}
		
		public function get sendMessageOnFailureSignal():ISignal {
			return _sendMessageOnFailureSignal;
		}
		
		public function ChatMessageService() {
		}
		
		public function setupMessageSenderReceiver():void {
			chatMessageSender = new ChatMessageSender(userSession, _sendMessageOnSuccessSignal, _sendMessageOnFailureSignal);
			chatMessageReceiver = new ChatMessageReceiver(userSession, chatMessagesSession);
			userSession.mainConnection.addMessageListener(chatMessageReceiver as IMessageListener);
		}
		
		public function getPublicChatMessages():void {
			chatMessageSender.getPublicChatMessages();
		}
		
		public function sendPublicMessage(message:ChatMessageVO):void {
			chatMessageSender.sendPublicMessage(message);
		}
		
		public function sendPrivateMessage(message:ChatMessageVO):void {
			chatMessageSender.sendPrivateMessage(message);
		}
		
		/**
		 * Creates new instance of ChatMessageVO with Welcome message as message string
		 * and imitates new public message being sent
		 **/
		public function sendWelcomeMessage():void {
			// retrieve welcome message from conference parameters
			var welcome:String = conferenceParameters.welcome;
			if (welcome != "") {
				var msg:ChatMessageVO = new ChatMessageVO();
				msg.chatType = "PUBLIC_CHAT"
				msg.fromUserID = " ";
				msg.fromUsername = " ";
				msg.fromColor = "86187";
				msg.fromLang = "en";
				msg.fromTime = new Date().time;
				msg.fromTimezoneOffset = new Date().timezoneOffset;
				msg.toUserID = " ";
				msg.toUsername = " ";
				msg.message = welcome;
				// imitate new public message being sent
				chatMessageReceiver.onMessage("ChatReceivePublicMessageCommand", msg);
			}
		}
	}
}
