package org.bigbluebutton.view.ui.micbutton {
	
	import flash.events.MouseEvent;
	
	import org.bigbluebutton.command.MicrophoneMuteSignal;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class MicButtonMediator extends SignalMediator {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var microphoneMuteSignal:MicrophoneMuteSignal;
		
		[Inject]
		public var view:MicButton;
		
		/**
		 * Initialize listeners and Mediator initial state
		 */
		override public function onRegister():void {
			(view as MicButton).addEventListener(MouseEvent.CLICK, mouseEventClickHandler);
			userSession.userList.userChangeSignal.add(userChangeHandler);
			view.setVisibility(userSession.userList.me.voiceJoined);
			view.muted = userSession.userList.me.muted;
		}
		
		/**
		 * Destroy view and listeners
		 */
		override public function onRemove():void {
			(view as MicButton).removeEventListener(MouseEvent.CLICK, mouseEventClickHandler);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			super.onRemove();
			view.dispose();
			view = null;
		}
		
		/**
		 * Handle events to turnOn microphone
		 */
		private function mouseEventClickHandler(e:MouseEvent):void {
			microphoneMuteSignal.dispatch(userSession.userList.me);
		}
		
		/**
		 * Update the view when there is a chenge in the model
		 */
		private function userChangeHandler(user:User, type:int):void {
			if (user && UserList && user.me) {
				if (type == UserList.JOIN_AUDIO) {
					view.setVisibility(user.voiceJoined);
				} else if (type == UserList.MUTE) {
					view.muted = user.muted;
				}
			}
		}
	}
}
