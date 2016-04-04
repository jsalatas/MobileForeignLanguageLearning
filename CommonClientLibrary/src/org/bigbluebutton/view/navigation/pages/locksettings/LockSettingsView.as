package org.bigbluebutton.view.navigation.pages.locksettings {
	
	import spark.components.Button;
	import spark.components.ToggleSwitch;
	
	import gr.ictpro.mall.client.components.CheckBox;
	
	public class LockSettingsView extends LockSettingsViewBase {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function get cameraSwitch():CheckBox {
			return cam;
		}
		
		public function get micSwitch():CheckBox {
			return mic;
		}
		
		public function get publicChatSwitch():CheckBox {
			return publicChat;
		}
		
		public function get privateChatSwitch():CheckBox {
			return privateChat;
		}
		
		public function get layoutSwitch():CheckBox {
			return layout0;
		}
		
		public function get applyButton():Button {
			return apply;
		}
		
		public function dispose():void {
		}
	}
}
