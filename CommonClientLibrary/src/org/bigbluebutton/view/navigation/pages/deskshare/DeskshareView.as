package org.bigbluebutton.view.navigation.pages.deskshare {
	
	import flash.display.Screen;
	import flash.display.StageOrientation;
	import flash.net.NetConnection;
	import flash.system.Capabilities;
	import mx.core.FlexGlobals;
	import spark.components.Group;
	import spark.components.Label;
	
	public class DeskshareView extends DeskshareViewBase  {
		private var deskshareVideoView:DeskshareVideoView;
		
		/**
		 * Provide access to the group containing video
		 */
		public function get deskshareGroup():Group {
			return deskshareGroup0;
		}
		
		/**
		 *  Create VideoView with the desktop sharing stream and add it to the layout
		 */
		public function startStream(connection:NetConnection, name:String, streamName:String, userID:String, width:Number, height:Number):void {
			if (deskshareVideoView)
				stopStream();
			deskshareVideoView = new DeskshareVideoView();
			deskshareVideoView.percentWidth = 100;
			deskshareVideoView.percentHeight = 100;
			this.addElement(deskshareVideoView);
			//if system is iOS, add the taskbar as part of the topbar for proper alignment 
			var topbarHeight = (Capabilities.version.indexOf('IOS') >= 0) ? Screen.mainScreen.bounds.height - this.height - FlexGlobals.topLevelApplication.bottomMenu.height : FlexGlobals.topLevelApplication.topActionBar.height;
			deskshareVideoView.startStream(connection, name, streamName, userID, width, height, this.deskshareGroup.height, this.deskshareGroup.width, topbarHeight, FlexGlobals.topLevelApplication.bottomMenu.height);
			deskshareVideoView.addMouseToStage();
			rotationHandler(FlexGlobals.topLevelApplication.currentOrientation);
		}
		
		public function changeMouseLocation(x:Number, y:Number):void {
			deskshareVideoView.moveMouse(x, y);
		}
		
		private function addMouseToStage():void {
			deskshareVideoView.addMouseToStage();
		}
		
		/**
		 * Close the video stream and remove video from layout
		 */
		public function stopStream():void {
			if (deskshareVideoView) {
				deskshareVideoView.close();
				if (this.deskshareGroup.containsElement(deskshareVideoView)) {
					this.deskshareGroup.removeElement(deskshareVideoView);
				}
				deskshareVideoView = null;
			}
		}
		
		/**
		 * Provide access to the notification message
		 */
		public function get noDeskshareMessage():Label {
			return noDeskshareMessage0;
		}
		
		override public function rotationHandler(rotation:String):void {
			if (deskshareVideoView != null) {
				switch (rotation) {
					case StageOrientation.ROTATED_LEFT:
						deskshareVideoView.rotateVideo(-90);
						break;
					case StageOrientation.ROTATED_RIGHT:
						deskshareVideoView.rotateVideo(90);
						break;
					case StageOrientation.UPSIDE_DOWN:
						deskshareVideoView.rotateVideo(180);
						break;
					case StageOrientation.DEFAULT:
					case StageOrientation.UNKNOWN:
					default:
						deskshareVideoView.rotateVideo(0);
				}
			}
		}
	}
}
