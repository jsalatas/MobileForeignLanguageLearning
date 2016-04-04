package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import org.bigbluebutton.view.navigation.pages.login.openroom.OpenRoomViewBase;
	import spark.components.Button;
	import spark.components.TextInput;
	
	public class OpenRoomView extends OpenRoomViewBase  {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function get inputRoom():TextInput {
			return inputRoom0;
		}
		
		public function get goButton():Button {
			return goButton0;
		}
		
		public function dispose():void {
		}
	}
}
