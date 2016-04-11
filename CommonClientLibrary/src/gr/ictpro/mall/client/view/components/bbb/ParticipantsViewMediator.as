package gr.ictpro.mall.client.view.components.bbb
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.robotlegs.mvcs.Mediator;
	
	public class ParticipantsViewMediator extends Mediator
	{
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
			view.participantsList.dataProvider = dataProvider;
			dicUserIdtoUser = new Dictionary();
			var users:ArrayCollection = userSession.userList.users;
			for each (var user:User in users) {
				addUser(user);
				if (user.me) {
					_userMe = user;
					view.participantsList.iAmPresenter = _userMe.presenter;
					view.presenterControls.visible = view.presenterControls.includeInLayout = _userMe!= null && _userMe.presenter;
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
		}
		
		private function userChanged(user:User, property:String = null):void {
			view.participantsList.iAmPresenter = _userMe!= null && _userMe.presenter;
			view.presenterControls.visible = view.presenterControls.includeInLayout = _userMe!= null && _userMe.presenter;
			dataProvider.refresh();
		}
		
		override public function onRemove():void {
			super.onRemove();
//			view.dispose();
			view = null;
			userSession.userList.userChangeSignal.remove(userChanged);
			userSession.userList.userAddedSignal.remove(addUser);
			userSession.userList.userRemovedSignal.remove(userRemoved);
		}
	}
}