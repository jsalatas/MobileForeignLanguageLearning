package org.bigbluebutton.view.navigation.pages.camerasettings {
	
	import org.bigbluebutton.view.navigation.pages.camerasettings.cameraprofiles.CameraProfilesList;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	import spark.components.Scroller;
	import spark.components.VideoDisplay;
	
	public class CameraSettingsView extends CameraSettingsViewBase {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get startCameraButton():Button {
			return startCameraButton0;
		}
		
		public function get swapCameraButton():Button {
			return swapCameraBtn0;
		}
		
		public function get cameraProfilesList():List {
			return cameraprofileslist;
		}
		
		public function get previewVideo():VideoDisplay {
			return previewvideo;
		}
		
		public function get videoGroup():Group {
			return videoGroup0;
		}
		
		public function get settingsGroup():Group {
			return settingsGroup0;
		}
		
		public function get noVideoMessage():Label {
			return noVideoMessage0;
		}
		
		public function get cameraSettingsScroller():Scroller {
			return cameraSettingsScroller0;
		}
		
		public function get rotateCameraButton():Button {
			return rotateCameraBtn0;
		}
	}
}
