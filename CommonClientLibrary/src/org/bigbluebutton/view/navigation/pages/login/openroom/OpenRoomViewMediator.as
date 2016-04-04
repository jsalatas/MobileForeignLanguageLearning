package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import mx.core.FlexGlobals;
	
	import spark.components.View;
	
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class OpenRoomViewMediator extends SignalMediator {
		
		[Inject]
		public var view:OpenRoomView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		override public function onRegister():void {
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = false;
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			(view as View).addEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			view.goButton.addEventListener(MouseEvent.CLICK, onGoButtonClick);
		}
		
		private function KeyHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				onGoButtonClick(null);
			}
		}
		
		private function onGoButtonClick(e:MouseEvent):void {
			var url:String = view.inputRoom.text;
			if (url.indexOf("http") == -1) {
				url = "http://" + url;
			}
			var urlReq:URLRequest = new URLRequest(url);
			navigateToURL(urlReq);
		}
		
		override public function onRemove():void {
			super.onRemove();
			(view as View).removeEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			view.goButton.removeEventListener(MouseEvent.CLICK, onGoButtonClick);
			view.dispose();
			view = null;
		}
	}
}
