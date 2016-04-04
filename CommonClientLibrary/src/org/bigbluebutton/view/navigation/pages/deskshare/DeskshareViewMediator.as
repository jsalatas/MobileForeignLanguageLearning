package org.bigbluebutton.view.navigation.pages.deskshare {
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class DeskshareViewMediator extends SignalMediator {
		
		[Inject]
		public var view:DeskshareView;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var params:ConferenceParameters;
		
		public override function onRegister():void {
			showDeskshare(userSession.deskshareConnection.streamWidth, userSession.deskshareConnection.streamHeight);
			userSession.deskshareConnection.isStreamingSignal.add(onDeskshareStreamChange);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			userSession.deskshareConnection.mouseLocationChangedSignal.add(onMouseLocationChanged);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'deskshare.title');
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
		}
		
		/**
		 * On Deskshare View initialization - start the video stream
		 */
		private function showDeskshare(width:Number, height:Number):void {
			view.noDeskshareMessage.visible = view.noDeskshareMessage.includeInLayout = false;
			view.startStream(userSession.deskshareConnection.connection, null, params.room, null, userSession.deskshareConnection.streamWidth, userSession.deskshareConnection.streamHeight);
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			if (userUISession.currentPage == PagesENUM.DESKSHARE) { //apply rotation only if user didn´t change view at the same time
				//reload deskshare page in order to load with the correct orientation
				userUISession.popPage();
				userUISession.pushPage(PagesENUM.DESKSHARE);
			}
		}
		
		/**
		 * If desktop sharing stream dropped - show notification message, remove video
		 * else show the desktop sharing stream and cursor
		 */
		public function onDeskshareStreamChange(isDeskshareStreaming:Boolean):void {
			view.noDeskshareMessage.visible = view.noDeskshareMessage.includeInLayout = !isDeskshareStreaming;
			if (!isDeskshareStreaming) {
				view.stopStream();
				userSession.deskshareConnection.mouseLocationChangedSignal.remove(onMouseLocationChanged);
			} else {
				userSession.deskshareConnection.mouseLocationChangedSignal.add(onMouseLocationChanged);
				showDeskshare(userSession.deskshareConnection.streamWidth, userSession.deskshareConnection.streamHeight);
			}
		}
		
		/**
		 * Notify view that mouse location was changed
		 */
		public function onMouseLocationChanged(x:Number, y:Number):void {
			view.changeMouseLocation(x, y);
		}
		
		/**
		 * Unsibscribe from signal listeners
		 * Stop desktop sharing stream
		 */
		override public function onRemove():void {
			userSession.deskshareConnection.isStreamingSignal.remove(onDeskshareStreamChange);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			userSession.deskshareConnection.mouseLocationChangedSignal.remove(onMouseLocationChanged);
			view.stopStream();
		}
	}
}
