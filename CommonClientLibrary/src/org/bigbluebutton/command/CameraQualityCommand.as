package org.bigbluebutton.command {
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.bigbluebutton.core.VideoConnection;
	import org.bigbluebutton.core.VideoProfile;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalCommand;
	
	
	public class CameraQualityCommand extends SignalCommand {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var cameraQualitySelected:VideoProfile;
		
		public function CameraQualityCommand() {
			super();
		}
		
		/**
		 * Set Camera Quality base on user selection
		 **/
		public override function execute():void {
			userSession.videoConnection.selectCameraQuality(cameraQualitySelected);
		}
	}
}
