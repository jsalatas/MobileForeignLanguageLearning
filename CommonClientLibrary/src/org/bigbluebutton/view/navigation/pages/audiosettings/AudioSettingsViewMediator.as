package org.bigbluebutton.view.navigation.pages.audiosettings {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.core.SaveData;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class AudioSettingsViewMediator extends SignalMediator {
		
		[Inject]
		public var view:AudioSettingsView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var saveData:SaveData;
		
		[Inject]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;
		
		private var autoJoined:Boolean;
		
		private var micActivityTimer:Timer = null;
		
		override public function onRegister():void {
			userSession.userList.userChangeSignal.add(userChangeHandler);
			FlexGlobals.topLevelApplication.pageName.text = Device.translations.getTranslation('Audio Settings');
			var userMe:User = userSession.userList.me;
			view.continueBtn.addEventListener(MouseEvent.CLICK, onContinueClick);
			view.enableAudio.addEventListener(Event.CHANGE, onEnableAudioClick);
			view.enableMic.addEventListener(Event.CHANGE, onEnableMicClick);
			view.enablePushToTalk.addEventListener(Event.CHANGE, onEnablePushToTalkClick);
			if (!userSession.phoneAutoJoin) {
				FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			}
			view.gainSlider.addEventListener(Event.CHANGE, gainChange);
			userSession.lockSettings.disableMicSignal.add(disableMic);
			disableMic(userSession.lockSettings.disableMic && userMe.role != User.MODERATOR && !userMe.presenter && userMe.locked);
			view.enableAudio.selected = (userMe.voiceJoined || userMe.listenOnly);
			view.enablePushToTalk.enabled = view.enableMic.selected = userMe.voiceJoined;
			view.enablePushToTalk.selected = (userSession.pushToTalk || userSession.phoneAutoJoin);
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			loadMicGain();
			micActivityTimer = new Timer(100);
			micActivityTimer.addEventListener(TimerEvent.TIMER, micActivity);
			micActivityTimer.start();
			view.continueBtn.visible = userSession.phoneAutoJoin;
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.popPage();
				if (userUISession.currentPage == PagesENUM.PROFILE) {
					userUISession.popPage();
				}
				userUISession.pushPage(PagesENUM.SPLITSETTINGS, PagesENUM.AUDIOSETTINGS);
			}
		}
		
		private function loadMicGain() {
			var gain = saveData.read("micGain");
			if (gain) {
				view.gainSlider.value = gain / 10;
			}
		}
		
		private function setMicGain(gain:Number) {
			if (userSession.voiceStreamManager) {
				userSession.voiceStreamManager.setDefaultMicGain(gain);
				if (!userSession.pushToTalk && userSession.voiceStreamManager.mic) {
					userSession.voiceStreamManager.mic.gain = gain;
				}
			}
		}
		
		private function gainChange(e:Event) {
			var gain:Number = e.target.value * 10
			saveData.save("micGain", gain);
			setMicGain(gain);
		}
		
		private function micActivity(e:TimerEvent):void {
			if (userSession.voiceStreamManager && userSession.voiceStreamManager.mic) {
				view.micActivityMask.width = view.gainSlider.width - (view.gainSlider.width * userSession.voiceStreamManager.mic.activityLevel / 100);
				view.micActivityMask.x = view.micActivity.x + view.micActivity.width - view.micActivityMask.width;
			}
		}
		
		private function disableMic(disable:Boolean):void {
			if (disable) {
				view.enableMic.enabled = false;
				view.enableMic.selected = false;
			} else {
				view.enableMic.enabled = true;
			}
		}
		
		private function onContinueClick(event:Event):void {
			userUISession.popPage();
		}
		
		private function onEnableAudioClick(event:Event):void {
			if (!view.enableAudio.selected) {
				view.enableMic.selected = false;
				view.enablePushToTalk.enabled = false;
				userSession.pushToTalk = false;
			}
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = view.enableMic.selected && view.enableAudio.selected;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = !view.enableMic.selected && view.enableAudio.selected;
			shareMicrophoneSignal.dispatch(audioOptions);
		}
		
		private function onEnableMicClick(event:Event):void {
			view.enablePushToTalk.enabled = view.enableMic.selected;
			if (view.enableMic.selected) {
				view.enableAudio.selected = true;
			}
			userSession.pushToTalk = (view.enablePushToTalk.selected && view.enablePushToTalk.enabled);
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = view.enableMic.selected && view.enableAudio.selected;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = !view.enableMic.selected && view.enableAudio.selected;
			shareMicrophoneSignal.dispatch(audioOptions);
		}
		
		private function onEnablePushToTalkClick(event:Event):void {
			userSession.pushToTalk = view.enablePushToTalk.selected;
		}
		
		private function userChangeHandler(user:User, type:int):void {
			if (user.me) {
				if (type == UserList.LISTEN_ONLY) {
					view.enableAudio.selected = user.voiceJoined || user.listenOnly;
					view.enableMic.selected = user.voiceJoined;
				}
			}
		}
		
		override public function onRemove():void {
			super.onRemove();
			userSession.lockSettings.disableMicSignal.remove(disableMic);
			view.continueBtn.removeEventListener(MouseEvent.CLICK, onContinueClick);
			view.enableAudio.removeEventListener(MouseEvent.CLICK, onEnableAudioClick);
			view.enableMic.removeEventListener(MouseEvent.CLICK, onEnableMicClick);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			if (micActivityTimer) {
				micActivityTimer.removeEventListener(TimerEvent.TIMER, micActivity);
			}
			view.enablePushToTalk.removeEventListener(MouseEvent.CLICK, onEnablePushToTalkClick);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			userSession.phoneAutoJoin = false;
		}
	}
}
