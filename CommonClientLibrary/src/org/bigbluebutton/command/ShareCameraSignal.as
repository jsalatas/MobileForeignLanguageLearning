package org.bigbluebutton.command {
	
	import flash.events.StageOrientationEvent;
	
	import org.osflash.signals.Signal;
	
	public class ShareCameraSignal extends Signal {
		public function ShareCameraSignal() {
			/**
			 * @1 camera enabled
			 * @2 camera position
			 */
			super(Boolean, Object);
		}
	}
}
