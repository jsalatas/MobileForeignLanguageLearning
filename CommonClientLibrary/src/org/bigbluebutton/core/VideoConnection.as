package org.bigbluebutton.core {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class VideoConnection extends DefaultConnectionCallback {
		private const LOG:String = "VideoConnection::";
		
		[Inject]
		public var baseConnection:BaseConnection;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var clientSettingsModel:ClientSettingsModel;
		
		[Inject]
		public var shareCameraSignal:ShareCameraSignal;
		
		private var _ns:NetStream;
		
		private var _cameraName:String;
		
		protected var _successConnected:ISignal = new Signal();
		
		protected var _unsuccessConnected:ISignal = new Signal();
		
		protected var _applicationURI:String;
		
		private var _camera:Camera;
		
		private var _selectedCameraQuality:VideoProfile;
		
		private var _selectedCameraRotation:int;
		
		[PostConstruct]
		public function init():void {
			baseConnection.init(this);
			userSession.successJoiningMeetingSignal.add(loadCameraSettings);
			baseConnection.successConnected.add(onConnectionSuccess);
			baseConnection.unsuccessConnected.add(onConnectionUnsuccess);
			userSession.lockSettings.disableCamSignal.add(disableCam);
		}
		
		private function disableCam(disable:Boolean):void {
			if (disable && userSession.userList.me.locked && !userSession.userList.me.presenter) {
				shareCameraSignal.dispatch(false, null);
			}
		}
		
		private function loadCameraSettings():void {
			if (clientSettingsModel.getItemById("camera_resolution") != null) {
				_selectedCameraQuality = userSession.videoProfileManager.getVideoProfileById(String(clientSettingsModel.getItemById("camera_resolution").value));
				if (!_selectedCameraQuality) {
					_selectedCameraQuality = userSession.videoProfileManager.defaultVideoProfile;
					trace("selected camera quality " + _selectedCameraQuality)
				}
			} else {
				_selectedCameraQuality = userSession.videoProfileManager.defaultVideoProfile;
			}
			if (clientSettingsModel.getItemById("camera_rotation") != null) {
				_selectedCameraRotation = int(clientSettingsModel.getItemById("camera_rotation").value);
			} else {
				_selectedCameraRotation = 0;
			}
			if (clientSettingsModel.getItemById("camera_name") != null) {
				_cameraName = String(clientSettingsModel.getItemById("camera_name").value);
			} else {
				_cameraName = "0";
			}
		}
		
		private function onConnectionUnsuccess(reason:String):void {
			unsuccessConnected.dispatch(reason);
		}
		
		private function onConnectionSuccess():void {
			_ns = new NetStream(baseConnection.connection);
			successConnected.dispatch();
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
		
		public function connect():void {
			baseConnection.connect(uri, conferenceParameters.meetingID, userSession.userId);
		}
		
		public function disconnect(onUserCommand:Boolean):void {
			baseConnection.disconnect(onUserCommand);
		}
		
		public function get cameraName():String {
			return _cameraName;
		}
		
		public function set cameraName(cameraName:String):void {
			_cameraName = cameraName;
		}
		
		public function get camera():Camera {
			return _camera;
		}
		
		public function set camera(value:Camera):void {
			_camera = value;
		}
		
		public function get selectedCameraQuality():VideoProfile {
			return _selectedCameraQuality;
		}
		
		public function set selectedCameraQuality(profile:VideoProfile):void {
			_selectedCameraQuality = profile;
		}
		
		public function get selectedCameraRotation():int {
			return (conferenceParameters.serverIsMconf) ? _selectedCameraRotation : 0;
		}
		
		public function set selectedCameraRotation(rotation:int):void {
			_selectedCameraRotation = rotation;
		}
		
		/**
		 * Set video quality based on the user selection
		 **/
		public function selectCameraQuality(profile:VideoProfile):void {
			if (selectedCameraRotation == 90 || selectedCameraRotation == 270) {
				camera.setMode(profile.height, profile.width, profile.modeFps);
			} else {
				camera.setMode(profile.width, profile.height, profile.modeFps);
			}
			trace("new cam resolution: " + camera.width + "x" + camera.height);
			camera.setQuality(profile.qualityBandwidth, profile.qualityPicture);
			selectedCameraQuality = profile;
		}
		
		public function startPublishing(camera:Camera, streamName:String):void {
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_ns.client = this;
			_ns.attachCamera(camera);
			switch (selectedCameraRotation) {
				case 90:
					streamName = "rotate_right/" + streamName;
					break;
				case 180:
					streamName = "rotate_left/rotate_left/" + streamName;
					break;
				case 270:
					streamName = "rotate_left/" + streamName;
					break;
			}
			_ns.publish(streamName);
		}
		
		private function onNetStatus(e:NetStatusEvent):void {
			trace(LOG + "onNetStatus() " + e.info.code);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(LOG + "onIOError() " + e.toString());
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void {
			trace(LOG + "onAsyncError() " + e.toString());
		}
		
		public function stopPublishing():void {
			if (_ns != null) {
				_ns.attachCamera(null);
				_ns.close();
				_ns = null;
				_ns = new NetStream(baseConnection.connection);
			}
		}
	}
}
