package org.bigbluebutton.view.navigation.pages.login {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.LoginService;
	import org.bigbluebutton.core.SaveData;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class LoginPageViewMediator extends SignalMediator {
		private const LOG:String = "LoginPageViewMediator::";
		
		[Inject]
		public var view:LoginPageView;
		
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		[Inject]
		public var loginService:LoginService;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var saveData:SaveData;
		
		private var count:Number = 0;
		
		override public function onRegister():void {
			//loginService.unsuccessJoinedSignal.add(onUnsucess);
			userUISession.unsuccessJoined.add(onUnsucess);
			view.tryAgainButton.addEventListener(MouseEvent.CLICK, tryAgain);
			joinRoom(userSession.joinUrl);
		}
		
		private function onUnsucess(reason:String):void {
			trace(LOG + "onUnsucess() " + reason);
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.visible = false;
			switch (reason) {
				case "emptyJoinUrl":
					if (!saveData.read("rooms")) {
						view.currentState = LoginPageViewBase.STATE_NO_REDIRECT;
					}
					break;
				case "invalidMeetingIdentifier":
					view.currentState = LoginPageViewBase.STATE_INVALID_MEETING_IDENTIFIER;
					break;
				case "checksumError":
					view.currentState = LoginPageViewBase.STATE_CHECKSUM_ERROR;
					break;
				case "invalidPassword":
					view.currentState = LoginPageViewBase.STATE_INVALID_PASSWORD;
					break;
				case "invalidURL":
					view.currentState = LoginPageViewBase.STATE_INAVLID_URL;
					break;
				case "genericError":
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
				case "authTokenTimedOut":
					view.currentState = LoginPageViewBase.STATE_AUTH_TOKEN_TIMEDOUT;
					break;
				case "authTokenInvalid":
					view.currentState = LoginPageViewBase.STATE_AUTH_TOKEN_INVALID;
					break;
				default:
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
			}
			// view.messageText.text = reason;
		}
		
		public function joinRoom(url:String) {
			if (Capabilities.isDebugger) {
				//saveData.save("rooms", null);
				// test-install server no longer works with 0.9 mobile client
				//url = "bigbluebutton://test-install.blindsidenetworks.com/bigbluebutton/api/join?fullName=Air&meetingID=Demo+Meeting&password=ap&checksum=512620179852dadd6fe0665a48bcb852a3c0afac";
				//url = "bigbluebutton://lab1.mconf.org/bigbluebut/api/join?fullName=User+4237921ton/api/join?fullName=Air+client&meetingID=Test+room+4&password=prof123&checksum=5805753edd08fbf9af50f9c28bb676c7e5241349"
				//url = "bigbluebutton://143.54.10.103/bigbluebutton/api/join?fullName=User+4704407&meetingID=random-3458293&password=mp&redirect=true&checksum=9102efa4f55e8b920b7f14b1c6bcdee7e0bb9c62";
				//url = "bigbluebutton://143.54.10.103/bigbluebutton/api/join?fullName=User+3569058&meetingID=random-1143106&password=mp&redirect=true&checksum=41f67390d73ca6fa149842bf082eef72d628c041";
				url = "bigbluebutton://192.168.0.20/bigbluebutton/api/join?meetingID=Demo+Meeting&fullName=test&password=mp&checksum=1f3a9cc3530a12f9e9cc83f9dde5e56a6dcb79e2";				
			}
			if (!url) {
				url = "";
			}
			if (url.lastIndexOf("://") != -1) {
				url = getEndURL(url);
			} else {
				userUISession.pushPage(PagesENUM.OPENROOM);
			}
			joinMeetingSignal.dispatch(url);
		}
		
		/**
		 * Replace the schema with "http"
		 */
		protected function getEndURL(origin:String):String {
			return origin.replace('bigbluebutton://', 'http://');
		}
		
		override public function onRemove():void {
			super.onRemove();
			//loginService.unsuccessJoinedSignal.remove(onUnsucess);
			userUISession.unsuccessJoined.remove(onUnsucess);
			view.dispose();
			view = null;
		}
		
		private function tryAgain(event:Event):void {
			FlexGlobals.topLevelApplication.mainshell.visible = false;
			userUISession.popPage();
			userUISession.pushPage(PagesENUM.LOGIN);
		}
	}
}
