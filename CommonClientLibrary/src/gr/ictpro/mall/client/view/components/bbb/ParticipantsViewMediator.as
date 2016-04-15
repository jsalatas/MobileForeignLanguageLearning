package gr.ictpro.mall.client.view.components.bbb
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.BBBMeetingView;
	
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.MicrophoneMuteSignal;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.command.PresenterSignal;
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ParticipantsViewMediator extends SignalMediator
	{
		[Inject]
		public var view:ParticipantsView;
		
		[Inject]
		public var userSession:UserSession
		
		[Inject]
		public var userUISession:UserUISession
		
		[Inject]
		public var usersService:UsersService;
		
		[Inject]
		public var presenterSignal:PresenterSignal;

		[Inject]
		public var moodSignal:MoodSignal;
		
		[Inject]
		public var microphoneMuteSignal:MicrophoneMuteSignal;

		[Inject]
		public var clearUserStatusSignal:ClearUserStatusSignal;
		
		protected var dataProvider:ArrayCollection;
		
		protected var dicUserIdtoUser:Dictionary;
		
		private var _userMe:User;
		
		private var allMuted:Boolean = true;
		private var presenterMuted:Boolean = false;
		
		override public function onRegister():void {
			dataProvider = new ArrayCollection();
			var participantsSort:Sort = new Sort();
			participantsSort.compareFunction = participantsCompare;
			dataProvider.sort = participantsSort;
			view.participantsList.dataProvider = dataProvider;
			dicUserIdtoUser = new Dictionary();
			var users:ArrayCollection = userSession.userList.users;
			for each (var user:User in users) {
				addUser(user);
				if (user.me) {
					_userMe = user;
					view.participantsList.me = _userMe;
					view.presenterControls.visible = view.presenterControls.includeInLayout = _userMe!= null && _userMe.presenter;
				}
			}
			addToSignal(userSession.userList.userChangeSignal, userChanged);
			addToSignal(userSession.userList.userAddedSignal, addUser);
			addToSignal(userSession.userList.userRemovedSignal, userRemoved);
			
			addToSignal(view.muteSignal, muteHandler);
			addToSignal(view.makePresenterSignal, makePresenterHandler);
			addToSignal(view.raiseHandSignal, raiseHandHandler);
			addToSignal(view.viewCameraSignal, viewCameraHandler);
			addToSignal(view.muteAllSignal, muteAllHandler);
			addToSignal(view.muteAllExPresenterSignal, muteAllExPresenterHandler);
			addToSignal(view.lowerHandsSignal, lowerHandsHandler);
			setMuteButtonLabel();
		}
		
		private function participantsCompare(user1:User, user2:User, fields:Array = null):int {
			if(user1.me) {
				return -1;
			}
			if(user2.me) {
				return 1;
			}

			if(user1.presenter) {
				return -1;
			}
			
			if(user2.presenter) {
				return 1;
			}

			if(user1.status == User.RAISE_HAND && user2.status != User.RAISE_HAND ) {
				return -1;
			}

			if(user1.status != User.RAISE_HAND && user2.status == User.RAISE_HAND ) {
				return 1;
			}
			
			return user1.name == user2.name?0:(user1.name < user2.name?-1:1);
		}

		private function muteHandler(user:User):void
		{
			if(_userMe.presenter || user.userID == _userMe.userID) {
				microphoneMuteSignal.dispatch(user);
			}			
		}
		
		private function makePresenterHandler(user:User):void
		{
			if(_userMe.presenter || _userMe.role == User.MODERATOR) {
				presenterSignal.dispatch(user, _userMe.userID);
			}

		}
		
		private function raiseHandHandler(user:User):void
		{
			if((_userMe.presenter && user.status == User.RAISE_HAND) || user.userID == _userMe.userID) {
				if(user.status == User.RAISE_HAND) {
					if(user.userID == _userMe.userID) {
						moodSignal.dispatch(User.NO_STATUS);
					} else {
						clearUserStatusSignal.dispatch(user.userID);
					}
				} else {
					moodSignal.dispatch(User.RAISE_HAND);
				}
			}			
			
		}

		private function viewCameraHandler(user:User):void
		{
			// This is ugly hack :(
			BBBMeetingView(view.parent.parent.parent).showVideo(user);
		}

		private function muteAllHandler():void
		{
			usersService.muteAllUsers(!allMuted);
		}

		private function muteAllExPresenterHandler():void
		{
			usersService.muteAllUsersExceptPresenter(!allMuted);
		}

		private function lowerHandsHandler():void
		{
			for each (var user:User in userSession.userList.users) {
				clearUserStatusSignal.dispatch(user.userID);
				userSession.userList.getUser(user.userID).status = User.NO_STATUS;
			}
	
		}

		private function addUser(user:User):void {
			setMuteButtonLabel();
			dataProvider.addItem(user);
			dataProvider.refresh();
			dicUserIdtoUser[user.userID] = user;
		}
		
		private function userRemoved(userID:String):void {
			var user:User = dicUserIdtoUser[userID] as User;
			var index:uint = dataProvider.getItemIndex(user);
			dataProvider.removeItemAt(index);
			dataProvider.refresh();
			dicUserIdtoUser[user.userID] = null;
		}
		
		private function userChanged(user:User, property:String = null):void {
			view.presenterControls.visible = view.presenterControls.includeInLayout = _userMe!= null && _userMe.presenter;
			dataProvider.refresh();
			setMuteButtonLabel();
		}
		
		private function setMuteButtonLabel():void {
			if(_userMe!= null && _userMe.presenter) {
				allMuted = true; 
				for each (var user:User in userSession.userList.users) {
					if(user.presenter) {
						presenterMuted = user.muted;
					} else {
						allMuted = allMuted && (user.voiceJoined && user.muted);
					}
				}				

				view.muteAll.label = Device.translations.getTranslation(allMuted?"Unmute All":"Mute All");
			}
		}
		
		override public function onRemove():void {
			super.onRemove();
//			view.dispose();
			view = null;
		}
	}
}