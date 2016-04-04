package org.bigbluebutton.view.navigation.pages.selectparticipant {
	
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	import mx.utils.ObjectUtil;
	
	import spark.events.IndexChangeEvent;
	import spark.events.ListEvent;
	
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
//salatas	import org.bigbluebutton.view.navigation.pages.splitsettings.SplitViewEvent;
	import org.osflash.signals.ISignal;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class SelectParticipantViewMediator extends SignalMediator {
		
		[Inject]
		public var view:SelectParticipantView;
		
		[Inject]
		public var userSession:UserSession
		
		[Inject]
		public var userUISession:UserUISession;
		
		protected var dataProvider:ArrayCollection;
		
		protected var dicUserIdtoUser:Dictionary
		
		protected var usersSignal:ISignal;
		
		protected var guestsSignal:ISignal;
		
		override public function onRegister():void {
			dataProvider = new ArrayCollection();
			view.list.dataProvider = dataProvider;
			view.list.addEventListener(IndexChangeEvent.CHANGE, onSelectUser);
			dicUserIdtoUser = new Dictionary();
			var users:ArrayCollection = userSession.userList.users;
			for each (var user:User in users) {
				if (!user.me) {
					userAdded(user)
				}
			}
			userSession.userList.userChangeSignal.add(userChanged);
			userSession.userList.userAddedSignal.add(userAdded);
			userSession.userList.userRemovedSignal.add(userRemoved);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'selectParticipant.title');
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			adjustForScreenRotation();
		}
		
		private function adjustForScreenRotation() {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.pushPage(PagesENUM.SPLITCHAT, userUISession.currentPageDetails);
			}
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			adjustForScreenRotation();
		}
		
		private function userAdded(user:User):void {
			dataProvider.addItem(user);
			dataProvider.refresh();
			dicUserIdtoUser[user.userID] = user;
		}
		
		private function userRemoved(userID:String):void {
			var user:User = dicUserIdtoUser[userID] as User;
			var index:uint = dataProvider.getItemIndex(user);
			dataProvider.removeItemAt(index);
			dicUserIdtoUser[user.userID] = null;
		}
		
		private function userChanged(user:User, property:String = null):void {
			dataProvider.refresh();
		}
		
		protected function onSelectUser(event:IndexChangeEvent):void {
			var user:User = dataProvider.getItemAt(event.newIndex) as User;
			if (FlexGlobals.topLevelApplication.isTabletLandscape()) {
//salatas				eventDispatcher.dispatchEvent(new SplitViewEvent(SplitViewEvent.CHANGE_VIEW, PagesENUM.getClassfromName(PagesENUM.CHAT), user, true));
			} else {
				userUISession.pushPage(PagesENUM.CHAT, user, TransitionAnimationENUM.SLIDE_LEFT);
			}
		}
		
		override public function onRemove():void {
			super.onRemove();
			view.dispose();
			view = null;
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			userSession.userList.userChangeSignal.remove(userChanged);
			userSession.userList.userAddedSignal.remove(userAdded);
			userSession.userList.userRemovedSignal.remove(userRemoved);
		}
	}
}
