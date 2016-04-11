package org.bigbluebutton.view.navigation.pages.participants {
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.robotlegs.mvcs.SignalMediator;
	
	use namespace mx_internal;

	public class ParticipantsViewMediator extends SignalMediator {
		
		[Inject]
		public var view:ParticipantsView;
		
		[Inject]
		public var userSession:UserSession
		
		[Inject]
		public var userUISession:UserUISession
		
		[Inject]
		public var usersService:UsersService;
		
		protected var dataProvider:ArrayCollection;
		
		protected var dicUserIdtoUser:Dictionary;
		
		private var _userMe:User;
		
		override public function onRegister():void {
			dataProvider = new ArrayCollection();
			view.list.dataProvider = dataProvider;
			dicUserIdtoUser = new Dictionary();
			var users:ArrayCollection = userSession.userList.users;
			for each (var user:User in users) {
				addUser(user);
				if (user.me) {
					_userMe = user;
				}
			}
			userSession.userList.userChangeSignal.add(userChanged);
			userSession.userList.userAddedSignal.add(addUser);
			userSession.userList.userRemovedSignal.add(userRemoved);
		}
		
		private function addUser(user:User):void {
			dataProvider.addItem(user);
			dataProvider.refresh();
			dicUserIdtoUser[user.userID] = user;
		}
		
		private function userRemoved(userID:String):void {
			var user:User = dicUserIdtoUser[userID] as User;
			var index:uint = dataProvider.getItemIndex(user);
			dataProvider.removeItemAt(index);
			dicUserIdtoUser[user.userID] = null;
			if (FlexGlobals.topLevelApplication.isTabletLandscape() && userUISession.currentPageDetails == user) {
				view.list.setSelectedIndex(0, true);
			}
		}
		
		private function userChanged(user:User, property:String = null):void {
			dataProvider.refresh();
		}
		
		override public function onRemove():void {
			super.onRemove();
			view.dispose();
			view = null;
			userSession.userList.userChangeSignal.remove(userChanged);
			userSession.userList.userAddedSignal.remove(addUser);
			userSession.userList.userRemovedSignal.remove(userRemoved);
		}
	}
}
