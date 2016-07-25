package gr.ictpro.mall.client.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import spark.core.SpriteVisualElement;
	
	import gr.ictpro.mall.client.components.Group;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.components.bbb.ChatView;
	import gr.ictpro.mall.client.view.components.bbb.MeetingSettingsView;
	import gr.ictpro.mall.client.view.components.bbb.ParticipantsView;
	import gr.ictpro.mall.client.view.components.bbb.ShowVideoEvent;
	import gr.ictpro.mall.client.view.components.bbb.VideoView;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.UsersService;

	public class BBBMeetingViewMediator extends TopBarCollaborationViewMediator
	{
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		[Inject]
		public var usersService:UsersService;
		
		protected var currentModule:*;
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			showView(new (MeetingSettingsView));

			joinMeetingSignal.dispatch(view.parameters.vo.url);
		}
		
		private function showView(currentModule:*):void
		{
			BBBMeetingView(view).container.removeAllElements();
			if(currentModule is Group) {
				BBBMeetingView(view).container.addElement(currentModule);
				view.stage.removeEventListener(ResizeEvent.RESIZE, resizeSharedBoard);
			} else {
				var container:UIComponent = new UIComponent();
				BBBMeetingView(view).container.addElement(container);
				container.width = BBBMeetingView(view).container.width;
				container.height = BBBMeetingView(view).container.height;
				container.addChild(currentModule);
				var scaleW:Number = container.width / currentModule.width;
				var scaleH:Number = container.height / currentModule.height;
				
				currentModule.width = currentModule.width*Math.min(scaleW, scaleH);
				currentModule.height = currentModule.height*Math.min(scaleW, scaleH);
				if(scaleW > scaleH) {
					currentModule.y = 0;
					currentModule.x = (FlexGlobals.topLevelApplication.stage.stageWidth - currentModule.width) / 2;   
				} else {
					currentModule.x = 0;
					currentModule.y = (FlexGlobals.topLevelApplication.stage.stageHeight - 30 - currentModule.height) / 2;   
					
				}

				view.stage.addEventListener(ResizeEvent.RESIZE, resizeSharedBoard);
				
			}
			this.currentModule = currentModule;
		}
		
		private function resizeSharedBoard(event:Event):void {
			var scaleW:Number = FlexGlobals.topLevelApplication.stage.stageWidth / currentModule.width;
			var scaleH:Number = (FlexGlobals.topLevelApplication.stage.stageHeight - Device.getScaledSize(30)) / currentModule.height;
			
			currentModule.parent.width = FlexGlobals.topLevelApplication.stage.stageWidth ;
			currentModule.parent.height = (FlexGlobals.topLevelApplication.stage.stageHeight - Device.getScaledSize(30));
			
			currentModule.width = currentModule.width*Math.min(scaleW, scaleH);
			currentModule.height = currentModule.height*Math.min(scaleW, scaleH);
			
			if(scaleW > scaleH) {
				currentModule.y = 0;
				currentModule.x = (FlexGlobals.topLevelApplication.stage.stageWidth - currentModule.width) / 2;   
			} else {
				currentModule.x = 0;
				currentModule.y = (FlexGlobals.topLevelApplication.stage.stageHeight - 30 - currentModule.height) / 2;   
				
			}

		}
		
		override protected function whiteboardClicked(event:MouseEvent):void
		{
			view.title = Device.translations.getTranslation("Board");
			if(currentModule == null || !(currentModule is view.parameters['boardClass'])) {
				showView(new view.parameters['boardClass']());
			} else {
				trace("already showing whiteboard");
			}
		}
		
		override protected function participantsClicked(event:MouseEvent):void
		{
			view.title = Device.translations.getTranslation("Participants");
			if(currentModule == null || !(currentModule is ParticipantsView)) {
				showView(new ParticipantsView());
			} else {
				trace("already showing participants");
			}
		}

		override protected function chatClicked(event:MouseEvent):void
		{
			view.title = Device.translations.getTranslation("Chat");
			if(currentModule == null || !(currentModule is ChatView)) {
				showView(new ChatView());
			} else {
				trace("already showing chat");
			}
		}

		override protected function videoClicked(event:ShowVideoEvent):void
		{
			view.title = Device.translations.getTranslation("Camera");
			if(currentModule == null || !(currentModule is VideoView)) {
				var v:VideoView = new VideoView();
				v.currentUser = event.user;
				showView(v);
			} else {
				trace("already showing video");
			}
		}

		override protected function settingsClicked(event:MouseEvent):void
		{
			view.title = Device.translations.getTranslation("Settings");
			if(currentModule == null || !(currentModule is MeetingSettingsView)) {
				var v:MeetingSettingsView = new MeetingSettingsView();
				showView(v);
			} else {
				trace("already showing settings");
			}
		}


	}
}