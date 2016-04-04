package org.bigbluebutton.view.navigation.pages.audiosettings {
	
	import spark.components.Button;
	import spark.components.HSlider;
	import spark.components.ToggleSwitch;
	import spark.primitives.Rect;
	
	import gr.ictpro.mall.client.components.CheckBox;
	
	public class AudioSettingsView extends AudioSettingsViewBase {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get enableMic():CheckBox {
			return enableMic0;
		}
		
		public function get enableAudio():CheckBox {
			return enableAudio0;
		}
		
		public function get enablePushToTalk():CheckBox {
			return enablePushToTalk0;
		}
		
		public function get continueBtn():Button {
			return continueToMeeting;
		}
		
		public function get gainSlider():HSlider {
			return gainSlider0;
		}
		
		public function get micActivity():Rect {
			return micActivity0;
		}
		
		public function get micActivityMask():Rect {
			return micActivityMask0;
		}
	}
}
