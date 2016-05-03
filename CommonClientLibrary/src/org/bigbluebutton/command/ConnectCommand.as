package org.bigbluebutton.command {
	
	import flash.media.Microphone;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.core.BigBlueButtonConnection;
	import org.bigbluebutton.core.ChatMessageService;
	import org.bigbluebutton.core.DeskshareConnection;
	import org.bigbluebutton.core.PresentationService;
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.core.VideoConnection;
	import org.bigbluebutton.core.VoiceConnection;
	import org.bigbluebutton.core.WhiteboardService;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ConnectCommand extends SignalCommand {
		private const LOG:String = "ConnectCommand::";
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var connection:BigBlueButtonConnection;
		
		[Inject]
		public var videoConnection:VideoConnection;
		
		[Inject]
		public var voiceConnection:VoiceConnection;
		
		[Inject]
		public var deskshareConnection:DeskshareConnection;
		
		[Inject]
		public var uri:String;
		
		[Inject]
		public var usersService:UsersService;
		
		[Inject]
		public var chatService:ChatMessageService;
		
		[Inject]
		public var presentationService:PresentationService;
		
		[Inject]
		public var whiteboardService:WhiteboardService;
		
		[Inject]
		public var disconnectUserSignal:DisconnectUserSignal;
		
		[Inject]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;
		
		[Inject]
		public var shareCameraSignal:ShareCameraSignal;
		
		[Inject]
		public var clientSettingsModel:ClientSettingsModel;
		
		override public function execute():void {
			loadConfigOptions();
			connection.uri = uri;
			connection.successConnected.add(successConnected);
			connection.unsuccessConnected.add(unsuccessConnected);
			connection.connect(conferenceParameters);
		}
		
		private function successConnected():void {
			trace(LOG + "successConnected()");
			userSession.mainConnection = connection;
			chatService.setupMessageSenderReceiver();
			whiteboardService.setupMessageSenderReceiver();
			userSession.userId = connection.userId;
			// Set up users message sender in order to send the "joinMeeting" message:
			usersService.setupMessageSenderReceiver();
			//send the join meeting message, then wait for the response
			//userSession.successJoiningMeetingSignal.add(successJoiningMeeting);
			//userSession.unsuccessJoiningMeetingSignal.add(unsuccessJoiningMeeting);
			userSession.authTokenSignal.add(onAuthTokenReply);
			userSession.loadedMessageHistorySignal.add(chatService.sendWelcomeMessage);
			usersService.validateToken();
			connection.successConnected.remove(successConnected);
			connection.unsuccessConnected.remove(unsuccessConnected);
		}
		
		private function onAuthTokenReply(tokenValid:Boolean):void {
			userSession.authTokenSignal.remove(onAuthTokenReply);
			if (tokenValid) {
				if (conferenceParameters.isGuestDefined() && conferenceParameters.guest) {
					userSession.guestPolicySignal.add(onGuestPolicyResponse);
					usersService.getGuestPolicy();
				} else {
					successJoiningMeeting();
				}
			} else {
				// TODO disconnect
			}
		}
		
		private function onGuestAllowed():void {
			successJoiningMeeting();
		}
		
		private function onGuestDenied():void {
			userUISession.loading = false;
			disconnectUserSignal.dispatch(DisconnectEnum.CONNECTION_STATUS_MODERATOR_DENIED);
		}
		
		private function onGuestPolicyResponse(policy:String):void {
			if (policy == UserSession.GUEST_POLICY_ALWAYS_ACCEPT) {
				onGuestAllowed();
			} else if (policy == UserSession.GUEST_POLICY_ALWAYS_DENY) {
				onGuestDenied();
			} else if (policy == UserSession.GUEST_POLICY_ASK_MODERATOR) {
				userUISession.pushPage(PagesENUM.GUEST);
				userUISession.loading = false;
				userSession.guestEntranceSignal.add(onGuestEntranceResponse);
			}
		}
		
		private function onGuestEntranceResponse(allowed:Boolean):void {
			if (allowed) {
				onGuestAllowed();
			} else {
				onGuestDenied();
			}
		}
		
		private function successJoiningMeeting():void {
			updateRooms();
			// Set up remaining message sender and receivers:
			presentationService.setupMessageSenderReceiver();
			// set up and connect the remaining connections
			videoConnection.uri = userSession.config.getConfigFor("VideoconfModule").@uri + "/" + conferenceParameters.room;
			//TODO see if videoConnection.successConnected is dispatched when it's connected properly
			videoConnection.successConnected.add(successVideoConnected);
			videoConnection.unsuccessConnected.add(unsuccessVideoConnected);
			videoConnection.connect();
			userSession.videoConnection = videoConnection;
			voiceConnection.uri = userSession.config.getConfigFor("PhoneModule").@uri;
			userSession.voiceConnection = voiceConnection;
			var audioOptions:Object;
			if (userSession.phoneAutoJoin && userSession.phoneSkipCheck) {
				var forceListenOnly:Boolean = (userSession.config.getConfigFor("PhoneModule").@forceListenOnly.toString().toUpperCase() == "TRUE") ? true : false;
				audioOptions = new Object();
				audioOptions.shareMic = userSession.userList.me.voiceJoined = !forceListenOnly;
				audioOptions.listenOnly = userSession.userList.me.listenOnly = forceListenOnly;
				shareMicrophoneSignal.dispatch(audioOptions);
			} else {
				audioOptions = new Object();
				
				var enableMic:Boolean = false;
				
				var mic:Microphone = Microphone.getEnhancedMicrophone(); 
				if(mic != null) {
					enableMic = clientSettingsModel.getItemById("enable_mic") != null? clientSettingsModel.getItemById("enable_mic").value.toLowerCase() == "true":false;
				}

				var enableAudio:Boolean = clientSettingsModel.getItemById("enable_audio") != null? clientSettingsModel.getItemById("enable_audio").value.toLowerCase() == "true":true;
				audioOptions.shareMic = userSession.userList.me.voiceJoined = enableMic;
				audioOptions.listenOnly = userSession.userList.me.listenOnly = enableAudio && !enableMic;
				shareMicrophoneSignal.dispatch(audioOptions);
			}
			deskshareConnection.applicationURI = userSession.config.getConfigFor("DeskShareModule").@uri;
			deskshareConnection.room = conferenceParameters.room;
			deskshareConnection.connect();
			userSession.deskshareConnection = deskshareConnection;
			// Query the server for chat, users, and presentation info
			chatService.sendWelcomeMessage();
			userSession.userList.allUsersAddedSignal.add(successUsersAdded);
			chatService.getPublicChatMessages();
			presentationService.getPresentationInfo();
			usersService.queryForParticipants();
			usersService.queryForRecordingStatus();
			userSession.successJoiningMeetingSignal.remove(successJoiningMeeting);
			userSession.unsuccessJoiningMeetingSignal.remove(unsuccessJoiningMeeting);
			//usersService.getRoomLockState();*/
		}
		
		private function updateRooms():void {
			var rooms:ArrayCollection = null; //saveData.read("rooms") as ArrayCollection;
			if (!rooms) {
				rooms = new ArrayCollection();
			}
			var roomName:String = conferenceParameters.meetingName;
			var roomUrl:String = (conferenceParameters.metadata && conferenceParameters.metadata.hasOwnProperty("invitation-url")) ? conferenceParameters.metadata['invitation-url'] : null;
			if (roomName) {
				var roomExists:Boolean = false;
				for (var i:int = rooms.length - 1; i >= 0; i--) {
					if (rooms[i].name == roomName && rooms[i].url == roomUrl) {
						rooms[i].timestamp = new Date();
						rooms.addItem(rooms.removeItemAt(i));
						roomExists = true;
						break;
					}
				}
				//saveData.save("rooms", rooms);
			}
		}
		
		private function unsuccessJoiningMeeting():void {
			trace(LOG + "unsuccessJoiningMeeting() -- Failed to join the meeting!!!");
			userSession.successJoiningMeetingSignal.remove(successJoiningMeeting);
			userSession.unsuccessJoiningMeetingSignal.remove(unsuccessJoiningMeeting);
		}
		
		private function successUsersAdded():void {
			// remove guest page (if it is there)
			userUISession.popPage();
			if (FlexGlobals.topLevelApplication.hasOwnProperty("topActionBar") && FlexGlobals.topLevelApplication.hasOwnProperty("bottomMenu")) {
				FlexGlobals.topLevelApplication.topActionBar.visible = true;
				FlexGlobals.topLevelApplication.bottomMenu.visible = true;
				FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = true;
			}
			userUISession.loading = false;
			userUISession.pushPage(PagesENUM.VIDEO_CHAT);
			if (conferenceParameters.serverIsMconf && !userSession.lockSettings.loaded) {
				userSession.lockSettings.disableMicSignal.add(displayAudioSettings);
			} else {
				displayAudioSettings();
			}
			if (userSession.videoAutoStart && !userSession.skipCamSettingsCheck) {
				userUISession.pushPage(PagesENUM.CAMERASETTINGS);
			}
			userSession.userList.allUsersAddedSignal.remove(successUsersAdded);
		}
		
		private function displayAudioSettings(micLocked:Boolean = false):void {
			userSession.lockSettings.disableMicSignal.remove(displayAudioSettings);
			if (userSession.phoneAutoJoin && !userSession.phoneSkipCheck && (userSession.userList.me.isModerator() || !userSession.lockSettings.disableMic)) {
				userUISession.pushPage(PagesENUM.AUDIOSETTINGS);
			} else {
				userSession.phoneAutoJoin = false;
			}
		}
		
		private function loadConfigOptions():void {
			userSession.phoneAutoJoin = (userSession.config.getConfigFor("PhoneModule").@autoJoin.toString().toUpperCase() == "TRUE") ? true : false;
			userSession.phoneSkipCheck = (userSession.config.getConfigFor("PhoneModule").@skipCheck.toString().toUpperCase() == "TRUE") ? true : false;
			userSession.videoAutoStart = (userSession.config.getConfigFor("VideoconfModule").@autoStart.toString().toUpperCase() == "TRUE") ? true : false;
			userSession.skipCamSettingsCheck = (userSession.config.getConfigFor("VideoconfModule").@skipCamSettingsCheck.toString().toUpperCase() == "TRUE") ? true : false;
		}
		
		private function unsuccessConnected(reason:String):void {
			trace(LOG + "unsuccessConnected()");
			userUISession.loading = false;
			userUISession.unsuccessJoined.dispatch("connectionFailed");
			connection.successConnected.remove(successConnected);
			connection.unsuccessConnected.remove(unsuccessConnected);
		}
		
		private function successVideoConnected():void {
			trace(LOG + "successVideoConnected()");
			var enableCamera:Boolean = clientSettingsModel.getItemById("enable_camera") != null? clientSettingsModel.getItemById("enable_camera").value.toLowerCase()=="true":false;
//			if (userSession.videoAutoStart && userSession.skipCamSettingsCheck) {
			if (enableCamera) {
				var orientation:String = FlexGlobals.topLevelApplication.stage.orientation;

				var cameraProperties:Object = new Object();
				cameraProperties.cameraName = userSession.videoConnection.cameraName;
				cameraProperties.orientation= 0; //Device.calcCameraRotation(userSession.videoConnection.cameraName, orientation);
				shareCameraSignal.dispatch(!userSession.userList.me.hasStream, cameraProperties);
			}
			videoConnection.successConnected.remove(successVideoConnected);
			videoConnection.unsuccessConnected.remove(unsuccessVideoConnected);
		}
		
		private function unsuccessVideoConnected(reason:String):void {
			trace(LOG + "unsuccessVideoConnected()");
			videoConnection.unsuccessConnected.remove(unsuccessVideoConnected);
			videoConnection.successConnected.remove(successVideoConnected);
		}
	}
}
