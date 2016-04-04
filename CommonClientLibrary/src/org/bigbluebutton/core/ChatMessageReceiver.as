package org.bigbluebutton.core {
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	
	public class ChatMessageReceiver implements IMessageListener {
		public var userSession:UserSession;
		
		public var chatMessagesSession:ChatMessagesSession;
		
		[Inject]
		public var chatService:ChatMessageService;
		
		public function ChatMessageReceiver(userSession:UserSession, chatMessagesSession:ChatMessagesSession) {
			this.userSession = userSession;
			this.chatMessagesSession = chatMessagesSession;
		}
		
		public function onMessage(messageName:String, message:Object):void {
			switch (messageName) {
				case "ChatReceivePublicMessageCommand":
					handleChatReceivePublicMessageCommand(message);
					break;
				case "ChatReceivePrivateMessageCommand":
					handleChatReceivePrivateMessageCommand(message);
					break;
				case "ChatRequestMessageHistoryReply":
					handleChatRequestMessageHistoryReply(message);
					break;
				default:
					//   LogUtil.warn("Cannot handle message [" + messageName + "]");
			}
		}
		
		private function handleChatRequestMessageHistoryReply(message:Object):void {
			var messages = JSON.parse(message.msg as String);
			var msgCount:Number = messages.length;
			chatMessagesSession.publicChat.messages = new ArrayCollection();
			chatMessagesSession.publicChat.resetNewMessages();
			for (var i:int = 0; i < msgCount; i++) {
				handleChatReceivePublicMessageCommand(messages[i]);
			}
			userSession.loadedMessageHistorySignal.dispatch();
		}
		
		private function handleChatReceivePublicMessageCommand(message:Object):void {
			trace("Handling public chat message [" + message.message + "]");
			var msg:ChatMessageVO = new ChatMessageVO();
			msg.chatType = message.chatType;
			msg.fromUserID = message.fromUserID;
			msg.fromUsername = message.fromUsername;
			msg.fromColor = message.fromColor;
			msg.fromLang = message.fromLang;
			msg.fromTime = message.fromTime;
			msg.fromTimezoneOffset = message.fromTimezoneOffset;
			msg.toUserID = message.toUserID;
			msg.toUsername = message.toUsername;
			msg.message = message.message;
			chatMessagesSession.publicChat.newChatMessage(msg);
		}
		
		private function handleChatReceivePrivateMessageCommand(message:Object):void {
			trace("Handling private chat message");
			var msg:ChatMessageVO = new ChatMessageVO();
			msg.chatType = message.chatType;
			msg.fromUserID = message.fromUserID;
			msg.fromUsername = message.fromUsername;
			msg.fromColor = message.fromColor;
			msg.fromLang = message.fromLang;
			msg.fromTime = message.fromTime;
			msg.fromTimezoneOffset = message.fromTimezoneOffset;
			msg.toUserID = message.toUserID;
			msg.toUsername = message.toUsername;
			msg.message = message.message;
			var userId:String = (msg.fromUserID == userSession.userId ? msg.toUserID : msg.fromUserID);
			var userName:String = (msg.fromUserID == userSession.userId ? msg.toUsername : msg.fromUsername);
			chatMessagesSession.newPrivateMessage(userId, userName, msg);
		}
	}
}
