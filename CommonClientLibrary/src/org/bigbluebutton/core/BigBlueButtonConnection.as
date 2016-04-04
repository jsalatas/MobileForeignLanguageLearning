package org.bigbluebutton.core {
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.model.ConferenceParameters;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class BigBlueButtonConnection extends DefaultConnectionCallback {
		public static const NAME:String = "BigBlueButtonConnection";
		
		protected var _successConnected:ISignal = new Signal();
		
		protected var _unsuccessConnected:ISignal = new Signal();
		
//		[Inject]
		public var baseConnection:BaseConnection = new BaseConnection();
		
		private var _applicationURI:String;
		
		private var _conferenceParameters:ConferenceParameters;
		
		private var _tried_tunneling:Boolean = false;
		
		private var _logoutOnUserCommand:Boolean = false;
		
		private var _userId:String;
		
		public function BigBlueButtonConnection() {
		}
		
		[PostConstruct]
		public function init():void {
			baseConnection.init(this);
			baseConnection.successConnected.add(onConnectionSuccess);
			baseConnection.unsuccessConnected.add(onConnectionUnsuccess);
		}
		
		private function onConnectionUnsuccess(reason:String):void {
			unsuccessConnected.dispatch(reason);
		}
		
		private function onConnectionSuccess():void {
			getMyUserId();
		}
		
		private function getMyUserId():void {
			baseConnection.connection.call("participants.getMyUserId",
										   new Responder(function(result:String):void {
											   trace("Success connected: My user ID is [" + result + "]");
											   _userId = result as String;
											   successConnected.dispatch();
										   },
										   function(status:Object):void {
											   trace("Error occurred");
											   trace(ObjectUtil.toString(status));
											   unsuccessConnected.dispatch("Failed to get the userId");
										   }
										   )
										   );
		}
		
		public function get unsuccessConnected():ISignal {
			return _unsuccessConnected;
		}
		
		public function get successConnected():ISignal {
			return _successConnected;
		}
		
		public function set uri(uri:String):void {
			_applicationURI = uri;
		}
		
		public function get uri():String {
			return _applicationURI;
		}
		
		public function get connection():NetConnection {
			return baseConnection.connection;
		}
		
		/**
		 * Connect to the server.
		 * uri: The uri to the conference application.
		 * username: Fullname of the participant.
		 * role: MODERATOR/VIEWER
		 * conference: The conference room
		 * mode: LIVE/PLAYBACK - Live:when used to collaborate, Playback:when being used to playback a recorded conference.
		 * room: Need the room number when playing back a recorded conference. When LIVE, the room is taken from the URI.
		 */
		public function connect(params:ConferenceParameters, tunnel:Boolean = false):void {
			_conferenceParameters = params;
			_tried_tunneling = tunnel;
			var uri:String = _applicationURI + "/" + _conferenceParameters.room;
			var lockSettings:Object = {
					disableCam: false,
					disableMic: false,
					disablePrivateChat: false,
					disablePublicChat: false,
					lockedLayout: false,
					lockOnJoin: false,
					lockOnJoinConfigurable: false
				};
			var connectParams:Array = [
				_conferenceParameters.username,
				_conferenceParameters.role,
				_conferenceParameters.room,
				_conferenceParameters.voicebridge,
				_conferenceParameters.record,
				_conferenceParameters.externUserID,
				_conferenceParameters.internalUserID,
				_conferenceParameters.muteOnStart,
				lockSettings
				];
			if (_conferenceParameters.isGuestDefined()) {
				trace(_conferenceParameters.guest);
				connectParams.push(_conferenceParameters.guest);
			}
			trace(connectParams);
			baseConnection.connect.apply(null, new Array(uri).concat(connectParams));
		}
		
		public function disconnect(onUserCommand:Boolean):void {
			baseConnection.disconnect(onUserCommand);
		}
		
		public function get userId():String {
			return _userId;
		}
		
		public function sendMessage(service:String, onSuccess:Function, onFailure:Function, message:Object = null):void {
			baseConnection.sendMessage(service, onSuccess, onFailure, message);
		}
	}
}
