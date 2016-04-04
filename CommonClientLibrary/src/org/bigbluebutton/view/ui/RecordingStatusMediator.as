package org.bigbluebutton.view.ui {
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class RecordingStatusMediator extends SignalMediator {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var view:RecordingStatus;
		
		override public function onRegister():void {
			userSession.recordingStatusChangedSignal.add(setRecordingStatus);
		}
		
		public function setRecordingStatus(recording:Boolean):void {
			view.setVisibility(recording);
			//try to keep page title center
			if (recording) {
				FlexGlobals.topLevelApplication.pageName.setStyle("paddingLeft", FlexGlobals.topLevelApplication.recordingStatus.getStyle("width"));
			} else {
				FlexGlobals.topLevelApplication.pageName.setStyle("paddingLeft", 0);
			}
		}
		
		override public function onRemove():void {
			userSession.recordingStatusChangedSignal.remove(setRecordingStatus);
		}
	}
}
