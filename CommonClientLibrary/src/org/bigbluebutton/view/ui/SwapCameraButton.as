package org.bigbluebutton.view.ui {
	
	import spark.components.Button;
	
	public class SwapCameraButton extends Button  {
		public function SwapCameraButton() {
			super();
		}
		
		public function setVisibility(val:Boolean):void {
			super.visible = val;
		}
		
		public function dispose():void {
			this.dispose();
		}
	}
}
