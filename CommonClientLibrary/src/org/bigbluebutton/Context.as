package org.bigbluebutton
{
	import gr.ictpro.mall.client.components.SharedBoard;
	import gr.ictpro.mall.client.view.SharedBoardMediator;
	
	import org.bigbluebutton.command.CameraQualityCommand;
	import org.bigbluebutton.command.CameraQualitySignal;
	import org.bigbluebutton.command.ChangeRoleCommand;
	import org.bigbluebutton.command.ChangeRoleSignal;
	import org.bigbluebutton.command.ClearUserStatusCommand;
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.ConnectCommand;
	import org.bigbluebutton.command.ConnectSignal;
	import org.bigbluebutton.command.DisconnectUserCommand;
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.command.JoinMeetingCommand;
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.command.LoadSlideCommand;
	import org.bigbluebutton.command.LoadSlideSignal;
	import org.bigbluebutton.command.LockUserCommand;
	import org.bigbluebutton.command.LockUserSignal;
	import org.bigbluebutton.command.MicrophoneMuteCommand;
	import org.bigbluebutton.command.MicrophoneMuteSignal;
	import org.bigbluebutton.command.MoodCommand;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.command.PresenterCommand;
	import org.bigbluebutton.command.PresenterSignal;
	import org.bigbluebutton.command.ShareCameraCommand;
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.command.ShareMicrophoneCommand;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.core.BaseConnection;
	import org.bigbluebutton.core.BigBlueButtonConnection;
	import org.bigbluebutton.core.ChatMessageService;
	import org.bigbluebutton.core.DeskshareConnection;
	import org.bigbluebutton.core.LoginService;
	import org.bigbluebutton.core.PresentationService;
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.core.VideoConnection;
	import org.bigbluebutton.core.VoiceConnection;
	import org.bigbluebutton.core.WhiteboardService;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	import org.bigbluebutton.view.navigation.pages.presentation.AnnotationControls;
	import org.bigbluebutton.view.navigation.pages.presentation.AnnotationControlsMediator;
	import org.bigbluebutton.view.navigation.pages.presentation.PresenterControls;
	import org.bigbluebutton.view.navigation.pages.presentation.PresenterControlsMediator;
	import org.bigbluebutton.view.navigation.pages.whiteboard.AnnotationIDGenerator;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvasMediator;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class Context extends ModuleContext
	{
		//TODO: For some reason keep unused rsls doesn't seem to work :(
		public var sbm:SharedBoardMediator; 
		public var sb:SharedBoard; 

		public function getInjector():IInjector
		{
			return injector;
		}
		
		override public function startup():void
		{
			
			////////////////////
			// 1 AppConfig
			////////////////////
			// Singleton mapping
			injector.mapSingleton(UserSession);
			injector.mapSingleton(ConferenceParameters);
			injector.mapSingleton(UsersService);
			injector.mapSingleton(ChatMessageService);
			injector.mapSingleton(PresentationService);
			injector.mapSingleton(WhiteboardService);
			injector.mapSingleton(ChatMessagesSession);
			injector.mapSingleton(DeskshareConnection);

			// Type mapping
			injector.mapClass(BaseConnection, BaseConnection);
			injector.mapClass(VoiceConnection, VoiceConnection);
			injector.mapClass(LoginService, LoginService);
			injector.mapClass(BigBlueButtonConnection, BigBlueButtonConnection);
			injector.mapClass(VideoConnection, VideoConnection);

			// Signal to Command mapping
			signalCommandMap.mapSignalClass(ConnectSignal, ConnectCommand);
			signalCommandMap.mapSignalClass(ShareMicrophoneSignal, ShareMicrophoneCommand);
			signalCommandMap.mapSignalClass(ShareCameraSignal, ShareCameraCommand);
			signalCommandMap.mapSignalClass(LoadSlideSignal, LoadSlideCommand);
			signalCommandMap.mapSignalClass(CameraQualitySignal, CameraQualityCommand);
			signalCommandMap.mapSignalClass(DisconnectUserSignal, DisconnectUserCommand);
			
			////////////////////
			// 3 PagesNavigatorConfig
			////////////////////
			signalCommandMap.mapSignalClass(JoinMeetingSignal, JoinMeetingCommand);


			////////////////////
			// 14 StatusConfig
			////////////////////
			signalCommandMap.mapSignalClass(MoodSignal, MoodCommand);

			////////////////////
			// 17 UserDetaisConfig
			////////////////////
			signalCommandMap.mapSignalClass(ClearUserStatusSignal, ClearUserStatusCommand);
			signalCommandMap.mapSignalClass(PresenterSignal, PresenterCommand);
			signalCommandMap.mapSignalClass(ChangeRoleSignal, ChangeRoleCommand);
			signalCommandMap.mapSignalClass(LockUserSignal, LockUserCommand);

			////////////////////
			// 20 MicButtonConfig
			////////////////////
			signalCommandMap.mapSignalClass(MicrophoneMuteSignal, MicrophoneMuteCommand);

			////////////////////
			// 21 VideoButtonConfig
			////////////////////
			signalCommandMap.mapSignalClass(ShareCameraSignal, ShareCameraCommand);
			
			////////////////////
			// 32 WhiteboardConfig
			////////////////////
			mediatorMap.mapView(WhiteboardCanvas, WhiteboardCanvasMediator);
			
			
			////////////////////
			// 33 mine
			////////////////////
			mediatorMap.mapView(PresenterControls, PresenterControlsMediator);
			mediatorMap.mapView(AnnotationControls, AnnotationControlsMediator);
			injector.mapSingleton(AnnotationIDGenerator);
		}
	}
}