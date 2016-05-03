package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import gr.ictpro.mall.client.components.IParameterizedView;
	import gr.ictpro.mall.client.components.TopBarCollaborationView;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.view.components.bbb.ShowVideoEvent;
	
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class TopBarCollaborationViewMediator extends SignalMediator
	{
		[Inject]
		public var view:TopBarCollaborationView;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var addView:AddViewSignal;

		public var cancelBack:Boolean = false;

		[Inject]
		public var userSession:UserSession;

		[Inject]
		public var shareCameraSignal:ShareCameraSignal;
		
		[Inject]
		public var disconnectUserSignal:DisconnectUserSignal;

		override public function onRegister():void
		{
			eventMap.mapListener(view, "backClicked", backClicked);
			eventMap.mapListener(view, "whiteboardClicked", whiteboardClicked);
			eventMap.mapListener(view, "videoClicked", videoClicked);
			eventMap.mapListener(view, "chatClicked", chatClicked);
			eventMap.mapListener(view, "participantsClicked", participantsClicked);
			eventMap.mapListener(view, "settingsClicked", settingsClicked);
			
			//Device.shellView.addEventListener(Event.RESIZE, orientationChangeHandler);

//			FlexGlobals.topLevelApplication.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler); 
		}

		override public function onRemove():void
		{
			super.onRemove();
//			FlexGlobals.topLevelApplication.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler); 
		}
		
//		private function orientationChangeHandler(e:StageOrientationEvent):void {
//			trace("@@@@@@@@@@@@@@@@@@@@@@@@" + e.beforeOrientation + " ---> " +e.afterOrientation);
//			if(Device.isAndroid && userSession.userList.me.hasStream) {
//				var cameraProperties:Object = new Object();
//				cameraProperties.beforeOrientation = Device.calcCameraRotation(userSession.videoConnection.cameraName, e.beforeOrientation);
//				cameraProperties.cameraName = userSession.videoConnection.cameraName;
//				cameraProperties.orientation = Device.calcCameraRotation(userSession.videoConnection.cameraName, e.afterOrientation);
//				shareCameraSignal.dispatch(true, cameraProperties);
//			}
//
//		}
	
		protected final function back():void
		{
			userSession.logoutSignal.dispatch();
			disconnectUserSignal.dispatch(DisconnectEnum.CONNECTION_STATUS_USER_LOGGED_OUT);

			backHandler();

			if(cancelBack)
				return; 
			
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView, view.masterView is IParameterizedView?IParameterizedView(view.masterView).parameters:null);
			}
			view.dispose();

		}
		
		protected function backHandler():void
		{
			
		}

		private function backClicked(event:MouseEvent):void
		{
			back();
		}

		protected function whiteboardClicked(event:MouseEvent):void
		{
			trace("whiteboardClicked");
		}

		protected function videoClicked(event:ShowVideoEvent):void
		{
			trace("videoClicked");
		}

		protected function chatClicked(event:MouseEvent):void
		{
			trace("chatClicked");
		}

		protected function participantsClicked(event:MouseEvent):void
		{
			trace("participantsClicked");
		}

		protected function settingsClicked(event:MouseEvent):void
		{
			trace("settingsClicked");
		}

	}
}