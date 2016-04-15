package gr.ictpro.mall.client.view.components.bbb
{
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.core.VideoProfile;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.pages.videochat.UserStreamName;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class VideoViewMediator extends SignalMediator
	{
		[Inject]
		public var view:VideoView;
		
		[Inject]
		public var userSession:UserSession;
		
		private var followSpeaker:Boolean = true;
		
		override public function onRegister():void {
			addToSignal(userSession.userList.userRemovedSignal, userRemovedHandler);
			addToSignal(userSession.userList.userChangeSignal, userChangeHandler);
			
			followSpeaker = view.currentUser == null;
			if(followSpeaker) {
				for each (var u:User in userSession.userList.users) {
					if(u.talking && u.hasStream) {
						userChangeHandler(u, UserList.TALKING);						
						break;
					}
				}
			} else {
				startStream(view.currentUser, view.currentUser.streamName);
			}
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		
		private function userRemovedHandler(userID:String):void {
				if (view.currentUser.userID == userID) {
					stopStream(userID);
				}
		}

		private function stopStream(userID:String):void {
			if (view) {
				view.stopStream();
			}
		}
		
		private function userChangeHandler(user:User, property:int):void {
			if (property == UserList.HAS_STREAM) {
				if (user.userID == view.currentUser.userID && !user.hasStream) {
					stopStream(user.userID);
				}
			} else if (property == UserList.TALKING) {
				if ((view.currentUser == null || user.userID != view.currentUser.userID) && user.hasStream && user.talking) {
					view.currentUser = user;
					startStream(user, user.streamName);
					trace("change user");
				}
				
			}
		}
		
		private function startStream(user:User, streamName:String):void {
			trace("++ start stream name " + streamName);
			if (view) {
				var videoProfile:VideoProfile = userSession.videoProfileManager.getVideoProfileByStreamName(streamName);
				trace(videoProfile.width + "x" + videoProfile.height);
				view.startStream(userSession.videoConnection.connection, user.name, streamName, user.userID, videoProfile.width, videoProfile.height, user.userID == userSession.userList.me.userID && !followSpeaker);
				view.currentUser = user;
				//view.videoGroup.height = view.video.height;
			}
		}

		
	}
}