package gr.ictpro.mall.client.view.components.bbb
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.utils.Timer;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.components.TopBarCollaborationView;
	import gr.ictpro.mall.client.view.BBBMeetingView;
	
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class MeetingSettingsViewMediator extends SignalMediator
	{
		[Inject]
		public var view:MeetingSettingsView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;

		private var micActivityTimer:Timer = null;

		private var microphoneWarningPopup:MicrophoneWarningPopup; 

		override public function onRegister():void
		{
			super.onRegister();
			
			addToSignal(view.cameraSettingsClicked, cameraSettingsHandler);
			addToSignal(userSession.userList.userChangeSignal, userChangeHandler);

			view.enableAudio.addEventListener(Event.CHANGE, onEnableAudioClick);
			view.enableMic.addEventListener(Event.CHANGE, onEnableMicClick);
			view.gainSlider.addEventListener(Event.CHANGE, gainChange);

			micActivityTimer = new Timer(100);
			micActivityTimer.addEventListener(TimerEvent.TIMER, micActivity);
			micActivityTimer.start();

		}
		
		override public function onRemove():void
		{
			super.onRemove();

			view.enableAudio.removeEventListener(MouseEvent.CLICK, onEnableAudioClick);
			view.enableMic.removeEventListener(MouseEvent.CLICK, onEnableMicClick);
			view.gainSlider.removeEventListener(Event.CHANGE, gainChange);

			if (micActivityTimer) {
				micActivityTimer.removeEventListener(TimerEvent.TIMER, micActivity);
			}
		}

		private function gainChange(e:Event) {
			var gain:Number = e.target.value * 10
			setMicGain(gain);
		}

		private function setMicGain(gain:Number) {
			if (userSession.voiceStreamManager) {
				userSession.voiceStreamManager.setDefaultMicGain(gain);
				if (!userSession.pushToTalk && userSession.voiceStreamManager.mic) {
					userSession.voiceStreamManager.mic.gain = gain;
				}
			}
		}
		
		private function onEnableAudioClick(event:Event):void {
			if (!view.enableAudio.selected) {
				view.enableMic.selected = false;
				userSession.pushToTalk = false;
			}
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = view.enableMic.selected && view.enableAudio.selected;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = !view.enableMic.selected && view.enableAudio.selected;
			shareMicrophoneSignal.dispatch(audioOptions);
		}
		
		private function microphoneWarningCloseHandler(e:PopUpEvent):void
		{
			microphoneWarningPopup.btnOk.removeEventListener(MouseEvent.CLICK, microphoneWarningOKHandler);
			microphoneWarningPopup.removeEventListener(PopUpEvent.CLOSE, microphoneWarningCloseHandler);
			microphoneWarningPopup = null;
			view.enableMic.selected = false;
		}

		private function microphoneWarningOKHandler(e:MouseEvent):void
		{
			microphoneWarningPopup.btnOk.removeEventListener(MouseEvent.CLICK, microphoneWarningOKHandler);
			microphoneWarningPopup.removeEventListener(PopUpEvent.CLOSE, microphoneWarningCloseHandler);
			microphoneWarningPopup.close();
			microphoneWarningPopup = null;
			
			enableMicrophone();
			
		}

		private function enableMicrophone():void {
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = view.enableMic.selected && view.enableAudio.selected;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = !view.enableMic.selected && view.enableAudio.selected;
			shareMicrophoneSignal.dispatch(audioOptions);
		}
		
		private function micActivity(e:TimerEvent):void {
			if (userSession.voiceStreamManager && userSession.voiceStreamManager.mic) {
				view.micActivityMask.width = view.gainSlider.width - (view.gainSlider.width * userSession.voiceStreamManager.mic.activityLevel / 100);
				view.micActivityMask.x = view.micActivity.x + view.micActivity.width - view.micActivityMask.width;
			}
		}

		private function onEnableMicClick(event:Event):void {
			if (view.enableMic.selected) {
				view.enableAudio.selected = true;
				
				var mic:Microphone = Microphone.getEnhancedMicrophone();
				if(mic == null) {
					microphoneWarningPopup = new MicrophoneWarningPopup();
					microphoneWarningPopup.open(this.view, true);
					microphoneWarningPopup.addEventListener(PopUpEvent.CLOSE, microphoneWarningCloseHandler);
					microphoneWarningPopup.btnOk.addEventListener(MouseEvent.CLICK, microphoneWarningOKHandler);
				} else {
					enableMicrophone();
				}					

			} else {
				enableMicrophone();
			}
		}

		
		private function userChangeHandler(user:User, type:int):void {
			if (user.me) {
				if (type == UserList.LISTEN_ONLY) {
					view.enableAudio.selected = user.voiceJoined || user.listenOnly;
					view.enableMic.selected = user.voiceJoined;
				}
			}
		}

		private function cameraSettingsHandler():void {
			TopBarCollaborationView(view.parent.parent.parent).showVideoSettings(userSession.userList.me);
		}
		
	}
}