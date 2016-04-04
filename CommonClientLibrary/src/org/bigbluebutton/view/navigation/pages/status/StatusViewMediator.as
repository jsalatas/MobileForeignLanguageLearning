package org.bigbluebutton.view.navigation.pages.status {
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	
	import spark.events.IndexChangeEvent;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.robotlegs.mvcs.SignalMediator;
	
	use namespace mx_internal;
	
	public class StatusViewMediator extends SignalMediator {
		
		[Inject]
		public var view:StatusView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var moodSignal:MoodSignal;
		
		override public function onRegister():void {
			var userMe:User = userSession.userList.me;
			view.moodList.addEventListener(IndexChangeEvent.CHANGE, onMoodChange);
			userSession.userList.userChangeSignal.add(userChanged);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			FlexGlobals.topLevelApplication.pageName.text = Device.translations.getTranslation('Change status');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			selectMood(userMe.status);
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.popPage();
				userUISession.popPage();
				userUISession.pushPage(PagesENUM.SPLITSETTINGS, PagesENUM.STATUS);
			}
		}
		
		private function userChanged(user:User, type:int):void {
			if (user == userSession.userList.me) {
				selectMood(user.status);
			}
		}
		
		private function selectMood(mood:String):void {
			for (var i:Number = 0; i < view.moodList.dataProvider.length; i++) {
				if (mood == view.moodList.dataProvider.getItemAt(i).signal) {
					view.moodList.setSelectedIndex(i);
					break;
				}
			}
		}
		
		protected function onMoodChange(event:IndexChangeEvent):void {
			var obj:Object;
			obj = view.moodList.selectedItem;
			moodSignal.dispatch(view.moodList.selectedItem.signal);
			if (!FlexGlobals.topLevelApplication.isTabletLandscape()) {
				userUISession.popPage();
				userUISession.popPage();
			}
		}
		
		override public function onRemove():void {
			super.onRemove();
			view.moodList.removeEventListener(IndexChangeEvent.CHANGE, onMoodChange);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			userSession.userList.userChangeSignal.remove(userChanged);
			view.dispose();
			view = null;
		}
	}
}
