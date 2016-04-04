package org.bigbluebutton.view.navigation.pages.exit {
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectType;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ExitPageViewMediator extends SignalMediator {
		
		[Inject]
		public var disconnectUserSignal:DisconnectUserSignal;
		
		[Inject]
		public var view:ExitPageView;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		private var _topBar:Boolean;
		
		private var _bottomMenu:Boolean;
		
		override public function onRegister():void {
			view.yesButton.addEventListener(MouseEvent.CLICK, applicationExit);
			view.noButton.addEventListener(MouseEvent.CLICK, backToApplication);
			changeConnectionStatus(userUISession.currentPageDetails as int);
			FlexGlobals.topLevelApplication.pageName.text = "";
			_topBar = FlexGlobals.topLevelApplication.topActionBar.visible;
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			_bottomMenu = FlexGlobals.topLevelApplication.bottomMenu.visible;
			FlexGlobals.topLevelApplication.bottomMenu.visible = false;
		}
		
		/**
		 * Sets the disconnect status based on disconnectionStatusCode received from DisconnectUserCommand
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
			disconnectUserSignal.dispatch(DisconnectEnum.CONNECTION_STATUS_USER_LOGGED_OUT);
			NativeApplication.nativeApplication.exit();
			if (conferenceParameters.logoutUrl) {
				var urlReq:URLRequest = new URLRequest(conferenceParameters.logoutUrl);
				navigateToURL(urlReq);
			}
		}
		
		private function backToApplication(event:Event):void {
			userUISession.popPage();
		}
		
		public override function onRemove():void {
			FlexGlobals.topLevelApplication.topActionBar.visible = _topBar;
			FlexGlobals.topLevelApplication.bottomMenu.visible = _bottomMenu;
		}
	}
}
