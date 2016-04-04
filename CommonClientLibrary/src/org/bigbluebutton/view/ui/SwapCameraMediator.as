package org.bigbluebutton.view.ui {
	
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	
	import mx.events.DragEvent;
	
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class SwapCameraMediator extends SignalMediator {
		
		[Inject]
		public var view:SwapCameraButton;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var shareCameraSignal:ShareCameraSignal;
		
		public override function onRegister():void {
			if (Camera.names.length > 1) {
				view.setVisibility(userSession.userList.me.hasStream);
				(view as SwapCameraButton).addEventListener(MouseEvent.CLICK, mouseClickHandler);
				userSession.userList.userChangeSignal.add(userChangeHandler);
			} else {
				(view as SwapCameraButton).includeInLayout = false;
			}
		}
		
		/**
		 * Raised on button click, will send signal to swap camera source
		 **/
		private function mouseClickHandler(e:MouseEvent):void {
			if (String(userSession.videoConnection.cameraPosition) == CameraPosition.FRONT) {
				shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.BACK);
			} else if (String(userSession.videoConnection.cameraPosition) == CameraPosition.BACK) {
				shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.FRONT);
			}
		}
		
		/**
		 * Update the view when there is a chenge in the model
		 */
		private function userChangeHandler(user:User, type:int):void {
			if (user.me && type == UserList.HAS_STREAM) {
				view.setVisibility(user.hasStream);
			}
		}
	}
}
