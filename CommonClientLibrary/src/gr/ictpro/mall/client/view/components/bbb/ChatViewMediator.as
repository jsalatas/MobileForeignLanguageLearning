package gr.ictpro.mall.client.view.components.bbb
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	
	import spark.components.List;
	import spark.components.View;
	import spark.events.ViewNavigatorEvent;
	
	import org.bigbluebutton.core.ChatMessageService;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.bigbluebutton.model.chat.ChatMessages;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ChatViewMediator extends SignalMediator
	{
		[Inject]
		public var view:ChatView;
		
		[Inject]
		public var chatMessageService:ChatMessageService;
		
		[Inject]
		public var userSession:UserSession;

		[Inject]
		public var chatMessagesSession:ChatMessagesSession;

		[Inject]
		public var userUISession:UserUISession;

		protected var dataProvider:ArrayCollection;
		

		override public function onRegister():void {
			var userMe:User = userSession.userList.me;
			//data = userUISession.currentPageDetails;
			openChat();
			var userLocked:Boolean = (!userSession.userList.me.presenter && userSession.userList.me.locked && userSession.userList.me.role != User.MODERATOR);
			disableChat(userSession.lockSettings.disablePublicChat && !userMe.presenter && userMe.locked);
			userSession.lockSettings.disablePublicChatSignal.add(disableChat);
			addToSignal(chatMessageService.sendMessageOnSuccessSignal, onSendSucess);
			addToSignal(chatMessageService.sendMessageOnFailureSignal, onSendFailure);
			addToSignal(chatMessagesSession.newChatMessageSignal, newChatMessageHandler);

		}
		
		private function newChatMessageHandler(UserID:String, publicChat:Boolean):void
		{
			// scroll the list to the current message
			view.callLater(focusNewRow); 	
		}
		
		private function focusNewRow():void 
		{
			view.chatlist.ensureIndexIsVisible(view.chatlist.dataProvider.length-1);
			view.callLater(view.forceListRedraw);
		}
		
		protected function openChat():void {
//			user = currentPageDetails.user;
//			view.pageName.text = currentPageDetails.name;
			var chatMessages:ChatMessages = chatMessagesSession.publicChat;
			chatMessages.resetNewMessages();
			dataProvider = chatMessages.messages as ArrayCollection;
			view.chatlist.dataProvider = dataProvider;
			view.callLater(view.forceListRedraw);
		}

		private function disableChat(disable:Boolean) {
			if (disable) {
				view.inputMessage.enabled = false;
				view.sendButton.enabled = false;
				view.removeEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
				view.sendButton.removeEventListener(MouseEvent.CLICK, onSendButtonClick);
			} else {
				view.inputMessage.enabled = true;
				view.sendButton.enabled = true;
				view.addEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
				view.sendButton.addEventListener(MouseEvent.CLICK, onSendButtonClick);
			}
		}

		private function KeyHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				onSendButtonClick(null);
			}
		}

		private function onSendSucess(result:String):void {
			view.inputMessage.enabled = true;
			view.inputMessage.text = "";
		}
		
		private function onSendFailure(status:String):void {
			view.inputMessage.enabled = true;
			view.sendButton.enabled = true;
		}

		private function onSendButtonClick(e:MouseEvent):void {
			view.inputMessage.enabled = false;
			view.sendButton.enabled = false;
			var currentDate:Date = new Date();
			//TODO get info from the right source
			var m:ChatMessageVO = new ChatMessageVO();
			m.fromUserID = userSession.userId;
			m.fromUsername = userSession.userList.getUser(userSession.userId).name;
			m.fromColor = "0";
			m.fromTime = currentDate.time;
			m.fromTimezoneOffset = currentDate.timezoneOffset;
			m.fromLang = "en";
			m.message = view.inputMessage.text;
			m.toUserID = "public_chat_userid";
			m.toUsername = "public_chat_username";
			m.chatType = "PUBLIC_CHAT";
			chatMessageService.sendPublicMessage(m);
		}
	}
}