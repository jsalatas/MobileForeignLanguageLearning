package org.bigbluebutton.core {
	
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.command.AuthenticationSignal;
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	
	public class UsersMessageReceiver implements IMessageListener {
		private const LOG:String = "UsersMessageReceiver::";
		
		public var userSession:UserSession;
		
		public var authenticationSignal:AuthenticationSignal;
		
		public var disconnectUserSignal:DisconnectUserSignal;
		
		private var lastSipEvent:Object = null;
		
		public function UsersMessageReceiver() {
		}
		
		public function onMessage(messageName:String, message:Object):void {
			switch (messageName) {
				case "voiceUserTalking":
					handleVoiceUserTalking(message);
					break;
				case "participantJoined":
					handleParticipantJoined(message);
					break;
				case "participantLeft":
					handleParticipantLeft(message);
					break;
				case "userJoinedVoice":
					handleUserJoinedVoice(message);
					break;
				case "userLeftVoice":
					handleUserLeftVoice(message);
					break;
				case "userSharedWebcam":
					handleUserSharedWebcam(message);
					break;
				case "userUnsharedWebcam":
					handleUserUnsharedWebcam(message);
					break;
				case "user_listening_only":
				case "userListeningOnly":
					handleUserListeningOnly(message);
					break;
				case "assignPresenterCallback":
					handleAssignPresenterCallback(message);
					break;
				case "voiceUserMuted":
					handleVoiceUserMuted(message);
					break;
				case "recordingStatusChanged":
					handleRecordingStatusChanged(message);
					break;
				case "joinMeetingReply":
					handleJoinedMeeting(message);
					break
				case "getUsersReply":
					handleGetUsersReply(message);
					break;
				case "getRecordingStatusReply":
					handleGetRecordingStatusReply(message);
					break;
				case "meetingHasEnded":
				case "meetingEnded":
					handleMeetingHasEnded(message);
					break;
				case "participantStatusChange":
					handleStatusChange(message);
					break;
				case "guest_access_denied":
				case "response_to_guest":
					handleGuestResponse(message);
					break;
				case "get_guest_policy_reply":
					handleGuestPolicy(message);
					break;
				case "validateAuthTokenTimedOut":
					handleValidateAuthTokenTimedOut(message);
					break;
				case "validateAuthTokenReply":
					handleValidateAuthTokenReply(message);
					break;
				case "participantRoleChange":
					handleParticipantRoleChange(message);
					break;
				case "userRaisedHand":
					handleParticipantRaisedHand(message);
					break;
				case "userLoweredHand":
					handleParticipantLoweredHand(message);
					break;
				case "meetingState":
					handleMeetingState(message);
					break;
				case "permissionsSettingsChanged":
					handlePermissionsSettingsChanged(message);
					break;
				case "meetingMuted":
					handleMeetingMuted(message);
					break;
				case "userLocked":
					handleUserLocked(message);
					break;
				case "sipVideoUpdate":
					handleSipVideoUpdate(message);
					break;
				default:
					break;
			}
		}
		
		private function handleSipVideoUpdate(msg:Object):void {
			trace("handleSipVideoUpdate " + msg.msg);
			var map:Object = JSON.parse(msg.msg);
			if (lastSipEvent != map) {
				if (userSession.globalVideoStreamName != map.sipVideoStreamName) {
					userSession.setGlobalVideoProfileDimensions(map.width, map.height);
					userSession.globalVideoStreamName = map.sipVideoStreamName;
				}
				lastSipEvent = map;
			}
		}
		
		private function handleUserLocked(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("handleUserLocked: " + ObjectUtil.toString(msg));
			trace("your id: " + userSession.userList.me.userID)
			var user:User = userSession.userList.getUserByUserId(msg.user);
			user.locked = msg.lock;
			if (userSession.userList.me.userID == msg.user) {
				userSession.dispatchLockSettings();
			}
		}
		
		private function handleMeetingMuted(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("handleMeetingMuted: " + ObjectUtil.toString(msg));
			userSession.meetingMuted = msg.meetingMuted;
		}
		
		private function handleMeetingState(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			userSession.meetingMuted = msg.meetingMuted;
			updateLockSettings(msg.permissions);
		}
		
		private function handlePermissionsSettingsChanged(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("permissionsSettingsChanged: " + ObjectUtil.toString(msg));
			updateLockSettings(msg);
		}
		
		private function handleParticipantRaisedHand(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("ParticipantRaisedHand: " + ObjectUtil.toString(msg));
			userSession.userList.statusChange(msg.userId, User.RAISE_HAND);
		}
		
		private function updateLockSettings(msg:Object):void {
			userSession.lockSettings.disableCam = msg.disableCam;
			userSession.lockSettings.disableMic = msg.disableMic;
			// bbb 1.0 compatibility: different variable names
			userSession.lockSettings.disablePrivateChat = msg.hasOwnProperty( "disablePrivChat" ) ? msg.disablePrivChat : msg.disablePrivateChat;
			userSession.lockSettings.disablePublicChat = msg.hasOwnProperty( "disablePubChat" ) ?  msg.disablePubChat : msg.disablePublicChat;
			userSession.lockSettings.lockedLayout = msg.lockedLayout;
			userSession.dispatchLockSettings();
		}
		
		private function handleParticipantLoweredHand(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("ParticipantLoweredHand: " + ObjectUtil.toString(msg));
			userSession.userList.statusChange(msg.userId, User.NO_STATUS);
		}
		
		private function handleParticipantRoleChange(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("ParticipantRoleChange: " + ObjectUtil.toString(msg));
			userSession.userList.roleChange(msg.userID, msg.role);
		}
		
		private function handleGuestPolicy(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("guestPolicy");
			userSession.guestPolicySignal.dispatch(msg.guestPolicy);
		}
		
		private function handleGuestResponse(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("GuestResponse: " + ObjectUtil.toString(msg));
			userSession.guestList.removeUser(msg.userId);
			if (msg.userId == userSession.userId) {
				userSession.guestEntranceSignal.dispatch(msg.response);
			}
		}
		
		private function handleStatusChange(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleStatusChange() -- user [" + msg.userID + "," + msg.value + "] ");
			var value:String = msg.value;
			switch (value.substr(0, value.indexOf(","))) {
				case "RAISE_HAND":
					userSession.userList.statusChange(msg.userID, User.RAISE_HAND);
					break;
				case "CLEAR_STATUS":
				case "CLEAR_MOOD":
				case "NO_STATUS":
					userSession.userList.statusChange(msg.userID, User.NO_STATUS);
					break;
				case "AGREE":
					userSession.userList.statusChange(msg.userID, User.AGREE);
					break;
				case "DISAGREE":
					userSession.userList.statusChange(msg.userID, User.DISAGREE);
					break;
				case "SPEAK_LOUDER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_LOUDER);
					break;
				case "SPEAK_LOWER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_LOWER);
					break;
				case "SPEAK_FASTER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_FASTER);
					break;
				case "SPEAK_SLOWER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_SLOWER);
					break;
				case "BE_RIGHT_BACK":
					userSession.userList.statusChange(msg.userID, User.BE_RIGHT_BACK);
					break;
				case "LAUGHTER":
					userSession.userList.statusChange(msg.userID, User.LAUGHTER);
					break;
				case "SAD":
					userSession.userList.statusChange(msg.userID, User.SAD);
					break;
			}
		}
		
		private function handleVoiceUserTalking(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			//trace(LOG + "handleVoiceUserTalking() -- user [" + +msg.voiceUserId + "," + msg.talking + "] ");
			userSession.userList.userTalkingChange(msg.voiceUserId, msg.talking);
		}
		
		private function handleGetUsersReply(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			for (var i:int; i < msg.users.length; i++) {
				var newUser:Object = msg.users[i];
				addParticipant(newUser);
			}
			userSession.userList.allUsersAddedSignal.dispatch();
		}
		
		private function handleParticipantJoined(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			var newUser:Object = msg.user;
			addParticipant(newUser);
		}
		
		private function addParticipant(newUser:Object):void {
			var user:User = new User;
			user.hasStream = newUser.hasStream;
			user.streamName = newUser.webcamStream;
			user.locked = newUser.locked;
			user.name = newUser.name;
			user.phoneUser = newUser.phoneUser;
			user.presenter = newUser.presenter;
			user.role = newUser.role;
			user.userID = newUser.userId;
			user.voiceJoined = newUser.voiceUser.joined;
			user.voiceUserId = newUser.voiceUser.userId;
			user.isLeavingFlag = false;
			user.listenOnly = newUser.listenOnly;
			user.muted = newUser.voiceUser.muted;
			user.guest = newUser.guest;
			user.waitingForAcceptance = newUser.waitingForAcceptance;
			var mood:String = newUser.mood;
			if (newUser.raiseHand) {
				user.status = User.RAISE_HAND;
			}
			if (mood) {
				switch (mood.substr(0, mood.indexOf(","))) {
					case "AGREE":
						user.status = User.AGREE;
						break;
					case "DISAGREE":
						user.status = User.DISAGREE;
						break;
					case "SPEAK_LOUDER":
						user.status = User.SPEAK_LOUDER;
						break;
					case "SPEAK_LOWER":
						user.status = User.SPEAK_LOWER;
						break;
					case "SPEAK_FASTER":
						user.status = User.SPEAK_FASTER;
						break;
					case "SPEAK_SLOWER":
						user.status = User.SPEAK_SLOWER;
						break;
					case "BE_RIGHT_BACK":
						user.status = User.BE_RIGHT_BACK;
						break;
					case "LAUGHTER":
						user.status = User.LAUGHTER;
						break;
					case "SAD":
						user.status = User.SAD;
						break;
					case "RAISE_HAND":
						user.status = User.RAISE_HAND;
						break;
					case "":
					case "CLEAR_MOOD":
						user.status = User.NO_STATUS;
						break;
				}
			}
			if (user.waitingForAcceptance) {
				userSession.guestList.addUser(user);
			} else {
				userSession.guestList.removeUser(user.userID);
				//if we are adding the userMe and he is already in the userList,we don't dispatch the guest signal
				// because we have already been accepted and connected
				if (!userSession.userList.getUser(user.userID) && user.userID == userSession.userId && user.guest) {
					userSession.guestEntranceSignal.dispatch(true);
				}
				userSession.userList.addUser(user);
			}
		}
		
		private function handleParticipantLeft(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleParticipantLeft() -- user [" + msg.user.userId + "] has left the meeting");
			userSession.userList.removeUser(msg.user.userId);
			userSession.guestList.removeUser(msg.user.userId);
		}
		
		private function handleAssignPresenterCallback(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleAssignPresenterCallback() -- user [" + msg.newPresenterID + "] is now the presenter");
			userSession.userList.assignPresenter(msg.newPresenterID);
		}
		
		private function handleUserJoinedVoice(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			var voiceUser:Object = msg.user.voiceUser;
			trace(LOG + "handleUserJoinedVoice() -- user [" + msg.user.userId + "] has joined voice with voiceId [" + voiceUser.userId + "]");
			userSession.userList.userJoinAudio(msg.user.userId, voiceUser.userId, voiceUser.muted, voiceUser.talking, voiceUser.locked);
		}
		
		private function handleUserLeftVoice(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleUserLeftVoice() -- user [" + msg.user.userId + "] has left voice");
			userSession.userList.userLeaveAudio(msg.user.userId);
		}
		
		private function handleUserSharedWebcam(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleUserSharedWebcam() -- user [" + msg.userId + "] has shared their webcam with stream [" + msg.webcamStream + "]");
			userSession.userList.userStreamChange(msg.userId, true, msg.webcamStream);
		}
		
		private function handleUserUnsharedWebcam(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleUserUnsharedWebcam() -- user [" + msg.userId + "] has unshared their webcam");
			userSession.userList.userStreamChange(msg.userId, false, msg.webcamStream);
		}
		
		private function handleUserListeningOnly(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleUserListeningOnly -- user [" + msg.userId + "] has listen only set to [" + userSession.userList.me.listenOnly + "]");
			userSession.userList.listenOnlyChange(msg.userId, userSession.userList.me.listenOnly);
		}
		
		private function handleVoiceUserMuted(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleVoiceUserMuted() -- user [" + msg.voiceUserId + ", muted: " + msg.muted + "]");
			userSession.userList.userMuteChange(msg.voiceUserId, msg.muted);
		}
		
		private function handleMeetingHasEnded(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleMeetingHasEnded() -- meeting has ended");
			userSession.logoutSignal.dispatch();
			disconnectUserSignal.dispatch(DisconnectEnum.CONNECTION_STATUS_MEETING_ENDED);
		}
		
		private function handleLogout(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleLogout() -- logging out!");
			userSession.logoutSignal.dispatch();
		}
		
		private function handleJoinedMeeting(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleJoinedMeeting() -- Joining meeting");
			userSession.joinMeetingResponse(msg);
		}
		
		private function handleRecordingStatusChanged(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace(LOG + "handleRecordingStatusChanged() -- recording status changed");
			userSession.recordingStatusChanged(msg.recording);
		}
		
		private function handleGetRecordingStatusReply(m:Object):void {
			trace(LOG + "handleGetRecordingStatusReply() -- recording status");
			var msg:Object = JSON.parse(m.msg);
			userSession.recordingStatusChanged(msg.recording);
		}
		
		private function handleValidateAuthTokenTimedOut(msg:Object):void {
			trace(LOG + "handleValidateAuthTokenTimedOut() " + msg.msg);
			authenticationSignal.dispatch("timedOut");
		}
		
		private function handleValidateAuthTokenReply(msg:Object):void {
			trace(LOG + "*** handleValidateAuthTokenReply " + msg.msg);
			var map:Object = JSON.parse(msg.msg);
			var tokenValid:Boolean = map.valid as Boolean;
			var userId:String = map.userId as String;
			trace(LOG + "handleValidateAuthTokenReply() valid=" + tokenValid);
			if (!tokenValid) {
				authenticationSignal.dispatch("invalid");
			} else {
				// why 2 different signals for authentication??  
				//userUISession.loading = false; in authentication command can break order of functions
				userSession.authTokenSignal.dispatch(true);
			}
		}
	}
}
