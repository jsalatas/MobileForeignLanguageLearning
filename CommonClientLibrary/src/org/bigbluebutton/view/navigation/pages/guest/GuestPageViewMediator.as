package org.bigbluebutton.view.navigation.pages.guest {
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.common.MenuButtons;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class GuestPageViewMediator extends SignalMediator {
		
		[Inject]
		public var view:GuestPageView;
		
		[Inject]
		public var userUISession:UserUISession;
		
		override public function onRegister():void {
			// If operating system is iOS, don't show exit button because there is no way to exit application:
			if (Capabilities.version.indexOf('IOS') >= 0) {
				view.exitButton.visible = false;
			} else {
				view.exitButton.addEventListener(MouseEvent.CLICK, applicationExit);
			}
			FlexGlobals.topLevelApplication.pageName.text = "";
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.visible = false;
		}
		
		private function applicationExit(event:Event):void {
			NativeApplication.nativeApplication.exit();
		}
	}
}
