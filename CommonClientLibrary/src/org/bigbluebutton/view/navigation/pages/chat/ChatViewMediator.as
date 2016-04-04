package org.bigbluebutton.view.navigation.pages.chat {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	
	import spark.components.List;
	import spark.components.View;
	import spark.events.ViewNavigatorEvent;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.core.ChatMessageService;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.model.chat.ChatMessage;
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.bigbluebutton.model.chat.ChatMessages;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.osflash.signals.ISignal;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ChatViewMediator extends SignalMediator {
		
		[Inject]
		public var view:ChatView;
		
		[Inject]
		public var chatMessageService:ChatMessageService;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var chatMessagesSession:ChatMessagesSession;
		
		protected var dataProvider:ArrayCollection;
		
		protected var usersSignal:ISignal;
		
		protected var list:List;
		
		protected var publicChat:Boolean = true;
		
		protected var user:User;
		
		protected var data:Object;
		
		protected var deltaHeight:Number;
		
		override public function onRegister():void {
			var userMe:User = userSession.userList.me;
			data = userUISession.currentPageDetails;
			if (data is User) {
				createNewChat(data as User);
			} else {
				openChat(data);
			}
			var userLocked:Boolean = (!userSession.userList.me.presenter && userSession.userList.me.locked && userSession.userList.me.role != User.MODERATOR);
			if (publicChat) {
				disableChat(userSession.lockSettings.disablePublicChat && !userMe.presenter && userMe.locked);
				userSession.lockSettings.disablePublicChatSignal.add(disableChat);
			} else {
				disableChat(userSession.lockSettings.disablePrivateChat && !userMe.presenter && userMe.locked);
				userSession.lockSettings.disablePrivateChatSignal.add(disableChat);
			}
			chatMessageService.sendMessageOnSuccessSignal.add(onSendSucess);
			chatMessageService.sendMessageOnFailureSignal.add(onSendFailure);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			list.addEventListener(FlexEvent.UPDATE_COMPLETE, scrollUpdate);
			userSession.userList.userRemovedSignal.add(userRemoved);
			userSession.userList.userAddedSignal.add(userAdded);
			(view as View).addEventListener(ViewNavigatorEvent.VIEW_DEACTIVATE, viewDeactivateHandler);
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			adjustForScreenRotation();
		}
		
		private function adjustForScreenRotation() {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.pushPage(PagesENUM.SPLITCHAT, userUISession.currentPageDetails);
			}
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			adjustForScreenRotation();
		}
		
		private function disableChat(disable:Boolean) {
			if (disable) {
				view.inputMessage.enabled = false;
				view.sendButton.enabled = false;
				(view as View).removeEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
				view.sendButton.removeEventListener(MouseEvent.CLICK, onSendButtonClick);
			} else {
				view.inputMessage.enabled = true;
				view.sendButton.enabled = true;
				(view as View).addEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
				view.sendButton.addEventListener(MouseEvent.CLICK, onSendButtonClick);
			}
		}
		
		private function KeyHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				onSendButtonClick(null);
			}
		}
		
		/**
		 * Reset new messages count when user leaves the page
		 * */
		protected function viewDeactivateHandler(event:ViewNavigatorEvent):void {
			var chatMessages:ChatMessages = null;
			if (data is User) {
				chatMessages = chatMessagesSession.getPrivateMessages(user.userID, user.name).privateChat;
			} else {
				chatMessages = data.chatMessages as ChatMessages;
			}
			chatMessages.resetNewMessages();
		}
		
		/**
		 * When user left the conference, add '[Offline]' to the username
		 * and disable text input
		 */
		protected function userRemoved(userID:String):void {
			if (view != null && user && user.userID == userID) {
				view.inputMessage.enabled = false;
				view.pageName.text = user.name + Device.translations.getTranslation('[Offline]');
			}
		}
		
		/**
		 * When user returned(refreshed the page) to the conference, remove '[Offline]' from the username
		 * and enable text input
		 */
		protected function userAdded(newuser:User):void {
			if ((view != null) && (user != null) && (user.userID == newuser.userID)) {
				view.inputMessage.enabled = true;
				view.pageName.text = user.name;
			}
		}
		
		protected function createNewChat(user:User):void {
			publicChat = false;
			this.user = user;
			view.pageName.text = user.name;
			view.inputMessage.enabled = chatMessagesSession.getPrivateMessages(user.userID, user.name).userOnline;
			dataProvider = chatMessagesSession.getPrivateMessages(user.userID, user.name).privateChat.messages;
			list = view.list;
			list.dataProvider = dataProvider;
		}
		
		protected function openChat(currentPageDetails:Object):void {
			publicChat = currentPageDetails.hasOwnProperty("publicChat") ? currentPageDetails.publicChat : null;
			user = currentPageDetails.user;
			view.pageName.text = currentPageDetails.name;
			if (!publicChat) {
				view.inputMessage.enabled = currentPageDetails.online;
				// if user went offline, and 'OFFLINE' marker is not already part of the string, add OFFLINE to the username
				if ((currentPageDetails.online == false) && (view.pageName.text.indexOf(Device.translations.getTranslation('[Offline]')) == -1)) {
					view.pageName.text += Device.translations.getTranslation('[Offline]');
				}
			}
			var chatMessages:ChatMessages = currentPageDetails.chatMessages as ChatMessages;
			chatMessages.resetNewMessages();
			dataProvider = chatMessages.messages as ArrayCollection;
			list = view.list;
			list.dataProvider = dataProvider;
		}
		
		private function scrollUpdate(e:Event):void {
			if (list.dataGroup.contentHeight > list.dataGroup.height) {
				if (list.dataGroup.getElementAt(0) && !deltaHeight) {
					deltaHeight = list.dataGroup.getElementAt(0).height / 2;
				}
				//included deltaHeight to fix spacing issue
				list.dataGroup.verticalScrollPosition = list.dataGroup.contentHeight - list.dataGroup.height + deltaHeight;
			}
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
			m.toUserID = publicChat ? "public_chat_userid" : user.userID;
			m.toUsername = publicChat ? "public_chat_username" : user.name;
			if (publicChat) {
				m.chatType = "PUBLIC_CHAT";
				chatMessageService.sendPublicMessage(m);
			} else {
				m.chatType = "PRIVATE_CHAT";
				chatMessageService.sendPrivateMessage(m);
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
		
		override public function onRemove():void {
			super.onRemove();
			list.removeEventListener(FlexEvent.UPDATE_COMPLETE, scrollUpdate);
			view.sendButton.removeEventListener(MouseEvent.CLICK, onSendButtonClick);
			chatMessageService.sendMessageOnSuccessSignal.remove(onSendSucess);
			chatMessageService.sendMessageOnFailureSignal.remove(onSendFailure);
			userSession.lockSettings.disablePublicChatSignal.remove(disableChat);
			userSession.lockSettings.disablePrivateChatSignal.remove(disableChat);
			userSession.userList.userRemovedSignal.remove(userRemoved);
			userSession.userList.userAddedSignal.remove(userAdded);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			(view as View).removeEventListener(ViewNavigatorEvent.VIEW_DEACTIVATE, viewDeactivateHandler);
			view.dispose();
			view = null;
		}
	}
}
