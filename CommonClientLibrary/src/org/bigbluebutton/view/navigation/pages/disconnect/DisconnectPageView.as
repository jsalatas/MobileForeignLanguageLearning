package org.bigbluebutton.view.navigation.pages.disconnect {
	
	import spark.components.Button;
	
	public class DisconnectPageView extends DisconnectPageViewBase  {
		public function get exitButton():Button {
			return exitButton0;
		}
		
		public function get reconnectButton():Button {
			return reconnectButton0;
		}
	}
}
