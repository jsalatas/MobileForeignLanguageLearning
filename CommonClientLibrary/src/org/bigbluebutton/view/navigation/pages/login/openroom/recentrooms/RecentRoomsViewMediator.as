package org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms {
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;
	
	import spark.events.IndexChangeEvent;
	
	import org.bigbluebutton.core.SaveData;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class RecentRoomsViewMediator extends SignalMediator {
		
		[Inject]
		public var view:RecentRoomsView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var saveData:SaveData;
		
		protected var dataProvider:ArrayCollection;
		
		override public function onRegister():void {
			if (saveData.read("rooms")) {
				dataProvider = new ArrayCollection((saveData.read("rooms") as ArrayCollection).toArray().reverse());
			}
			view.roomsList.dataProvider = dataProvider;
			view.roomsList.addEventListener(MouseEvent.CLICK, selectRoom);
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'recentRooms.title');
			FlexGlobals.topLevelApplication.topActionBar.visible = true;
			FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = false;
			FlexGlobals.topLevelApplication.backBtn.includeInLayout = true;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
		}
		
		protected function selectRoom(event:MouseEvent):void {
			trace("trying to select a room");
			if (view.roomsList.selectedIndex >= 0) {
				trace(dataProvider[view.roomsList.selectedIndex].url);
				if (dataProvider[view.roomsList.selectedIndex].url) {
					var urlReq = new URLRequest(dataProvider[view.roomsList.selectedIndex].url);
					navigateToURL(urlReq);
				}
			}
		}
		
		override public function onRemove():void {
			super.onRemove();
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			view.roomsList.removeEventListener(IndexChangeEvent.CHANGE, selectRoom);
			view.dispose();
			view = null;
		}
	}
}
