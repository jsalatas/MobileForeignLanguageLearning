package org.bigbluebutton.view.ui.videobutton {
	
	import flash.events.MouseEvent;
	import mx.events.FlexEvent;
	import mx.states.SetStyle;
	import mx.states.State;
	import spark.components.Button;
	
	public class VideoButton extends Button{
		public function VideoButton() {
			super();
		}
		
		public function dispose():void {
		}
		
		public function setVisibility(val:Boolean):void {
			this.visible = val;
			this.includeInLayout = val;
		}
	}
}
