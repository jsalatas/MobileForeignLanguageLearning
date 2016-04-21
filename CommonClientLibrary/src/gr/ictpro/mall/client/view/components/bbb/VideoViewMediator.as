package gr.ictpro.mall.client.view.components.bbb
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Video;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.command.CameraQualitySignal;
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.core.VideoProfile;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class VideoViewMediator extends SignalMediator
	{
		[Inject]
		public var view:VideoView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var changeQualitySignal:CameraQualitySignal;

		[Inject]
		public var shareCameraSignal:ShareCameraSignal;

		[Inject]
		public var clientSettingsModel:ClientSettingsModel;
		
		private var followSpeaker:Boolean = true;

		protected var dataProvider:ArrayCollection;

		override public function onRegister():void {
			addToSignal(userSession.userList.userRemovedSignal, userRemovedHandler);
			addToSignal(userSession.userList.userChangeSignal, userChangeHandler);
			addToSignal(view.resolutionChangeSignal, resolutionChangeHandler);
			addToSignal(view.switchCameraSignal, switchCameraHandler);
			addToSignal(view.shareMyCameraSignal, shareCameraHandler);
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
			if(view.currentState == "me") {
				if(view.currentUser.hasStream) {
					view.shareCamera.label = Device.translations.getTranslation("Stop Sharing");
				} else {
					view.shareCamera.label = Device.translations.getTranslation("Start Sharing");
				}
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
			if(!Device.isAndroid) {
				trace("hello");
			}
			if (property == UserList.HAS_STREAM) {
				if (user.userID == view.currentUser.userID && userSession.userList.me.userID != user.userID) {
					if(user.hasStream) {
						startStream(user, user.streamName);
					} else {
						stopStream(user.userID);
					}
					
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
			if (view) {
				if(user.userID == userSession.userList.me.userID) {
					view.currentState = "me";
					view.currentUser = user;
					if(user.hasStream) {
						view.shareCamera.label = Device.translations.getTranslation("Stop Sharing");
					} else {
						view.shareCamera.label = Device.translations.getTranslation("Start Sharing");
					}
					
					if (Camera.names.length <= 1) {
						view.switchCamera.enabled = false;
					} else {
						view.switchCamera.enabled = !user.hasStream;
					}
					initCameraProfiles();
					var profile:VideoProfile = userSession.videoConnection.selectedCameraQuality;

					trace("++ viewing my camera");
					if(userSession.videoConnection.cameraName== null) {
						userSession.videoConnection.cameraName= "0";
					}
					showPreview(profile);
					
				} else {
					trace("++ start stream name " + streamName);
					var videoProfile:VideoProfile = userSession.videoProfileManager.getVideoProfileByStreamName(streamName);
					trace(videoProfile.width + "x" + videoProfile.height);
					view.currentUser = user;
					view.startStream(userSession.videoConnection.connection, user.name, streamName, user.userID, videoProfile.width, videoProfile.height, user.userID == userSession.userList.me.userID && !followSpeaker);
					//view.videoGroup.height = view.video.height;
				}
			}
		}

		private function showPreview(profile:VideoProfile):void {
			var camera:Camera = Camera.getCamera(userSession.videoConnection.cameraName);
			
			camera.setMode(profile.width, profile.height, profile.modeFps);
			
			//view.startPreview(camera, camera.height, camera.width); 
			view.startPreview(camera, camera.height, camera.width); 
		}
		

		private function resolutionChangeHandler():void
		{
			var profile:VideoProfile = VideoProfile(view.resolution.selected);
			if (userSession.userList.me.hasStream) {
				var obj:Object = new Object();
				obj.name = "camera_resolution";
				obj.value = profile.id;
				clientSettingsModel.saveObject(obj);
				changeQualitySignal.dispatch(profile);
			}
			
			showPreview(profile);
		}

		private function shareCameraHandler():void
		{
			var enableCamera:Boolean = false;
			if(view.currentUser.hasStream) {
				view.shareCamera.label = Device.translations.getTranslation("Start Sharing");
			} else {
				enableCamera=true;
				view.shareCamera.label = Device.translations.getTranslation("Stop Sharing");
			}
			var orientation:String = FlexGlobals.topLevelApplication.stage.orientation;
			var cameraProperties:Object = new Object();
			cameraProperties.cameraName = userSession.videoConnection.cameraName;
			cameraProperties.orientation= 0; //Device.calcCameraRotation(userSession.videoConnection.cameraName, orientation);
			shareCameraSignal.dispatch(!userSession.userList.me.hasStream, cameraProperties);
			var obj:Object = new Object();
			obj.name = "enable_camera";
			obj.value = enableCamera;
			clientSettingsModel.saveObject(obj);
			var obj1:Object = new Object();
			obj1.name = "camera_name";
			obj1.value = userSession.videoConnection.cameraName;
			clientSettingsModel.saveObject(obj1);

		}
		
		private function switchCameraHandler():void
		{
			if (!userSession.userList.me.hasStream) {
				if(userSession.videoConnection.cameraName == "0") {
					userSession.videoConnection.cameraName = "1";
				} else {
					userSession.videoConnection.cameraName = "0";
				}
				
//				if (String(userSession.videoConnection.cameraPosition) == CameraPosition.FRONT) {
//					userSession.videoConnection.cameraPosition = CameraPosition.BACK;
//				} else {
//					userSession.videoConnection.cameraPosition = CameraPosition.FRONT;
//				}
			} else {
				var orientation:String = FlexGlobals.topLevelApplication.stage.orientation;
				var newCameraName:String;
				if(userSession.videoConnection.cameraName == "0") {
					newCameraName = "1";
				} else {
					newCameraName = "0";
				}
				
				var cameraProperties:Object = new Object();
				cameraProperties.beforeCameraName = userSession.videoConnection.cameraName;
				cameraProperties.cameraName = newCameraName;
				cameraProperties.orientation =0; //Device.calcCameraRotation(newCameraName, orientation);
				shareCameraSignal.dispatch(true, cameraProperties);
				var obj:Object = new Object();
				obj.name = "camera_name";
				obj.value = newCameraName;
				clientSettingsModel.saveObject(obj);

			}

			var profile:VideoProfile = userSession.videoConnection.selectedCameraQuality;
			showPreview(profile);
		}
		
		private function initCameraProfiles():void {
			var videoProfiles:Array = userSession.videoProfileManager.profiles;
			dataProvider = new ArrayCollection(videoProfiles);
			dataProvider.refresh();
			view.resolution.dataList = dataProvider;
			view.resolution.selected = userSession.videoConnection.selectedCameraQuality;
		}



		
	}
}