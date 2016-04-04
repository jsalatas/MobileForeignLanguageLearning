package org.bigbluebutton.view.navigation.pages.profile {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ProfileViewMediator extends SignalMediator {
		
		[Inject]
		public var view:ProfileView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var moodSignal:MoodSignal;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var clearUserStatusSignal:ClearUserStatusSignal;
		
		[Inject]
		public var userService:UsersService;
		
		private var navigateToStatus:Function = navigateTo(PagesENUM.STATUS);
		
		private var navigateToCameraSettings:Function = navigateTo(PagesENUM.CAMERASETTINGS);
		
		private var navigateToAudioSettings:Function = navigateTo(PagesENUM.AUDIOSETTINGS);
		
		private var navigateToLockSettings:Function = navigateTo(PagesENUM.LOCKSETTINGS);
		
		override public function onRegister():void {
			view.currentState = (conferenceParameters.serverIsMconf) ? "mconf" : "bbb";
			var userMe:User = userSession.userList.me;
			changeStatusIcon(userMe.status);
			disableCamButton(userSession.lockSettings.disableCam && !userMe.presenter && userMe.locked && userMe.role != User.MODERATOR);
			userSession.lockSettings.disableCamSignal.add(disableCamButton);
			if (userMe.role != User.MODERATOR) {
				displayManagementButtons(false);
			} else {
				setMuteState(userSession.meetingMuted);
				view.clearAllStatusButton.addEventListener(MouseEvent.CLICK, onClearAllButton);
				view.unmuteAllButton.addEventListener(MouseEvent.CLICK, onUnmuteAllButton);
				view.muteAllButton.addEventListener(MouseEvent.CLICK, onMuteAllButton);
				view.muteAllExceptPresenterButton.addEventListener(MouseEvent.CLICK, onMuteAllExceptPresenterButton);
			}
			if (!conferenceParameters.serverIsMconf) {
				view.clearAllStatusButton.label = Device.translations.getTranslation('Lower all hands');
				view.clearAllStatusButton.styleName = "lowerAllHandsButtonStyle videoAudioSettingStyle contentFontSize";
			}
			userSession.userList.userChangeSignal.add(userChanged);
			view.logoutButton.addEventListener(MouseEvent.CLICK, logoutClick);
			view.handButton.addEventListener(MouseEvent.CLICK, raiseHandClick);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			FlexGlobals.topLevelApplication.pageName.text = Device.translations.getTranslation('User Settings');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			addNavigationListeners();
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.popPage();
				userUISession.pushPage(PagesENUM.SPLITSETTINGS);
			}
		}
		
		private function changeStatusIcon(status:String) {
			switch (status) {
				case User.RAISE_HAND:
					view.statusButton.styleName = "handStatusButtonStyle videoAudioSettingStyle contentFontSize";
					view.handButton.label = Device.translations.getTranslation('Lower hand');
					break;
				case User.AGREE:
					view.statusButton.styleName = "agreeStatusButtonStyle";
					break;
				case User.DISAGREE:
					view.statusButton.styleName = "disagreeStatusButtonStyle";
					break;
				case User.SPEAK_LOUDER:
					view.statusButton.styleName = "speakLouderStatusButtonStyle";
					break;
				case User.SPEAK_LOWER:
					view.statusButton.styleName = "speakSofterStatusButtonStyle";
					break;
				case User.SPEAK_FASTER:
					view.statusButton.styleName = "speakFasterStatusButtonStyle";
					break;
				case User.SPEAK_SLOWER:
					view.statusButton.styleName = "speakSlowerStatusButtonStyle";
					break;
				case User.BE_RIGHT_BACK:
					view.statusButton.styleName = "beRightBackStatusButtonStyle";
					break;
				case User.LAUGHTER:
					view.statusButton.styleName = "laughterStatusButtonStyle";
					break;
				case User.SAD:
					view.statusButton.styleName = "sadStatusButtonStyle";
					break;
				case User.NO_STATUS:
					view.statusButton.styleName = "noStatusButtonStyle";
					break;
			}
			view.statusButton.styleName += " profileSettingsButtonStyle videoAudioSettingStyle contentFontSize";
		}
		
		private function addNavigationListeners():void {
			view.statusButton.addEventListener(MouseEvent.CLICK, navigateToStatus);
			view.shareCameraButton.addEventListener(MouseEvent.CLICK, navigateToCameraSettings);
			view.shareMicButton.addEventListener(MouseEvent.CLICK, navigateToAudioSettings);
			view.lockViewersButton.addEventListener(MouseEvent.CLICK, navigateToLockSettings);
		}
		
		private function removeNavigationListeners():void {
			view.statusButton.removeEventListener(MouseEvent.CLICK, navigateToStatus);
			view.shareCameraButton.removeEventListener(MouseEvent.CLICK, navigateToCameraSettings);
			view.shareMicButton.removeEventListener(MouseEvent.CLICK, navigateToAudioSettings);
			view.lockViewersButton.removeEventListener(MouseEvent.CLICK, navigateToLockSettings);
		}
		
		private function navigateTo(view:String) {
			return function(e:MouseEvent):void {
				if (FlexGlobals.topLevelApplication.isTabletLandscape()) {
//salatas					eventDispatcher.dispatchEvent(new SplitViewEvent(SplitViewEvent.CHANGE_VIEW, PagesENUM.getClassfromName(view), true))
				} else {
					userUISession.pushPage(view);
				}
			}
		}
		
		private function setMuteState(muted:Boolean) {
			if (muted) {
				view.muteAllButton.visible = false;
				view.muteAllButton.includeInLayout = false;
				view.muteAllExceptPresenterButton.visible = false;
				view.muteAllExceptPresenterButton.includeInLayout = false;
				view.unmuteAllButton.visible = true;
				view.unmuteAllButton.includeInLayout = true;
			} else {
				view.muteAllButton.visible = true;
				view.muteAllButton.includeInLayout = true;
				view.muteAllExceptPresenterButton.visible = true;
				view.muteAllExceptPresenterButton.includeInLayout = true;
				view.unmuteAllButton.visible = false;
				view.unmuteAllButton.includeInLayout = false;
			}
		}
		
		private function disableCamButton(disable:Boolean) {
			if (disable) {
				view.shareCameraButton.visible = false;
				view.shareCameraButton.includeInLayout = false;
			} else {
				view.shareCameraButton.visible = true;
				view.shareCameraButton.includeInLayout = true;
			}
		}
		
		/**
		 * User pressed log out button
		 */
		public function logoutClick(event:MouseEvent):void {
			userUISession.pushPage(PagesENUM.EXIT);
		}
		
		public function raiseHandClick(event:MouseEvent):void {
			if (userSession.userList.me.status == User.RAISE_HAND) {
				moodSignal.dispatch(User.NO_STATUS);
			} else {
				moodSignal.dispatch(User.RAISE_HAND);
			}
			userUISession.popPage();
		}
		
		protected function onClearAllButton(event:MouseEvent):void {
			for each (var user:User in userSession.userList.users) {
				clearUserStatusSignal.dispatch(user.userID);
				userSession.userList.getUser(user.userID).status = User.NO_STATUS;
			}
			userUISession.popPage();
		}
		
		protected function onMuteAllButton(event:MouseEvent):void {
			userService.muteAllUsers(true);
			setMuteState(true);
			userUISession.popPage();
		}
		
		protected function onUnmuteAllButton(event:MouseEvent):void {
			userService.muteAllUsers(false);
			setMuteState(false);
			userUISession.popPage();
		}
		
		protected function onMuteAllExceptPresenterButton(event:MouseEvent):void {
			userService.muteAllUsersExceptPresenter(true);
			setMuteState(true);
			userUISession.popPage();
		}
		
		private function displayManagementButtons(display:Boolean):void {
			view.clearAllStatusButton.visible = display;
			view.clearAllStatusButton.includeInLayout = display;
			view.muteAllButton.visible = display;
			view.muteAllButton.includeInLayout = display;
			view.muteAllExceptPresenterButton.visible = display;
			view.muteAllExceptPresenterButton.includeInLayout = display;
			view.lockViewersButton.visible = display;
			view.lockViewersButton.includeInLayout = display;
			view.unmuteAllButton.visible = display;
			view.unmuteAllButton.includeInLayout = display;
		}
		
		private function userChanged(user:User, type:int):void {
			if (userSession.userList.me.userID == user.userID) {
				changeStatusIcon(user.status);
				if (userSession.userList.me.role == User.MODERATOR) {
					displayManagementButtons(true);
					setMuteState(userSession.meetingMuted);
				} else {
					displayManagementButtons(false);
				}
			}
		}
		
		override public function onRemove():void {
			super.onRemove();
			view.logoutButton.removeEventListener(MouseEvent.CLICK, logoutClick);
			userSession.lockSettings.disableCamSignal.remove(disableCamButton);
			userSession.userList.userChangeSignal.remove(userChanged);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			removeNavigationListeners();
			view.dispose();
			view = null;
		}
	}
}
