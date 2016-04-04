package org.bigbluebutton.view.navigation.pages.disconnect {
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.common.MenuButtons;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectType;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class DisconnectPageViewMediator extends SignalMediator {
		
		[Inject]
		public var view:DisconnectPageView;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var userSession:UserSession;
		
		override public function onRegister():void {
			// If operating system is iOS, don't show exit button because there is no way to exit application:
			if (Capabilities.version.indexOf('IOS') >= 0) {
				view.exitButton.visible = false;
			} else {
				view.exitButton.addEventListener(MouseEvent.CLICK, applicationExit);
			}
			view.reconnectButton.addEventListener(MouseEvent.CLICK, reconnect);
			changeConnectionStatus(userUISession.currentPageDetails as int);
			if (FlexGlobals.topLevelApplication.hasOwnProperty("pageName")) {
				FlexGlobals.topLevelApplication.pageName.text = "";
				FlexGlobals.topLevelApplication.topActionBar.visible = false;
				FlexGlobals.topLevelApplication.bottomMenu.visible = false;
			}
		}
		
		/**
		 * Sets the disconnect status based on disconnectionStatusCode recieved from DisconnectUserCommand
		 */
		public function changeConnectionStatus(disconnectionStatusCode:int):void {
			switch (disconnectionStatusCode) {
				case DisconnectEnum.CONNECTION_STATUS_MEETING_ENDED:
					view.currentState = DisconnectType.CONNECTION_STATUS_MEETING_ENDED_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_CONNECTION_DROPPED:
					view.currentState = DisconnectType.CONNECTION_STATUS_CONNECTION_DROPPED_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_USER_KICKED_OUT:
					view.currentState = DisconnectType.CONNECTION_STATUS_USER_KICKED_OUT_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_USER_LOGGED_OUT:
					view.currentState = DisconnectType.CONNECTION_STATUS_USER_LOGGED_OUT_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_MODERATOR_DENIED:
					view.currentState = DisconnectType.CONNECTION_STATUS_MODERATOR_DENIED_STRING;
					break;
			}
		}
		
		private function applicationExit(event:Event):void {
			trace("DisconnectPageViewMediator.applicationExit - exitting the application!");
			userSession.logoutSignal.dispatch();
			NativeApplication.nativeApplication.exit();
		}
		
		private function reconnect(event:Event):void {
			trace("DisconnectPageViewMediator.reconnect - attempting to reconnect");
			userUISession.popPage();
			if (FlexGlobals.topLevelApplication.hasOwnProperty("mainshell")) {
				FlexGlobals.topLevelApplication.mainshell.visible = false;
			}
			userUISession.pushPage(PagesENUM.LOGIN);
		}
	}
}
