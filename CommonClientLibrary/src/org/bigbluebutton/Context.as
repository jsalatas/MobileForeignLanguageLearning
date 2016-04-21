package org.bigbluebutton
{
	import org.bigbluebutton.command.AuthenticationCommand;
	import org.bigbluebutton.command.AuthenticationSignal;
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
	import org.bigbluebutton.command.NavigateToCommand;
	import org.bigbluebutton.command.NavigateToSignal;
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
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	import org.bigbluebutton.view.navigation.PagesNavigatorView;
	import org.bigbluebutton.view.navigation.PagesNavigatorViewMediator;
	import org.bigbluebutton.view.navigation.pages.common.MenuButtonsView;
	import org.bigbluebutton.view.navigation.pages.common.MenuButtonsViewMediator;
	import org.bigbluebutton.view.navigation.pages.disconnect.DisconnectPageView;
	import org.bigbluebutton.view.navigation.pages.disconnect.DisconnectPageViewMediator;
	import org.bigbluebutton.view.navigation.pages.exit.ExitPageView;
	import org.bigbluebutton.view.navigation.pages.exit.ExitPageViewMediator;
	import org.bigbluebutton.view.navigation.pages.guest.GuestPageView;
	import org.bigbluebutton.view.navigation.pages.guest.GuestPageViewMediator;
	import org.bigbluebutton.view.navigation.pages.locksettings.LockSettingsView;
	import org.bigbluebutton.view.navigation.pages.locksettings.LockSettingsViewMediator;
	import org.bigbluebutton.view.navigation.pages.presentation.AnnotationControls;
	import org.bigbluebutton.view.navigation.pages.presentation.AnnotationControlsMediator;
	import org.bigbluebutton.view.navigation.pages.presentation.PresenterControls;
	import org.bigbluebutton.view.navigation.pages.presentation.PresenterControlsMediator;
	import org.bigbluebutton.view.navigation.pages.profile.ProfileView;
	import org.bigbluebutton.view.navigation.pages.profile.ProfileViewMediator;
	import org.bigbluebutton.view.navigation.pages.selectparticipant.SelectParticipantView;
	import org.bigbluebutton.view.navigation.pages.selectparticipant.SelectParticipantViewMediator;
	import org.bigbluebutton.view.navigation.pages.status.StatusView;
	import org.bigbluebutton.view.navigation.pages.status.StatusViewMediator;
	import org.bigbluebutton.view.navigation.pages.userdetails.UserDetaisView;
	import org.bigbluebutton.view.navigation.pages.userdetails.UserDetaisViewMediator;
	import org.bigbluebutton.view.navigation.pages.videochat.VideoChatView;
	import org.bigbluebutton.view.navigation.pages.videochat.VideoChatViewMediator;
	import org.bigbluebutton.view.navigation.pages.whiteboard.AnnotationIDGenerator;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvasMediator;
	import org.bigbluebutton.view.ui.NavigationButton;
	import org.bigbluebutton.view.ui.NavigationButtonMediator;
	import org.bigbluebutton.view.ui.RecordingStatus;
	import org.bigbluebutton.view.ui.RecordingStatusMediator;
	import org.bigbluebutton.view.ui.micbutton.MicButton;
	import org.bigbluebutton.view.ui.micbutton.MicButtonMediator;
	import org.bigbluebutton.view.ui.videobutton.VideoButton;
	import org.bigbluebutton.view.ui.videobutton.VideoButtonMediator;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class Context extends ModuleContext
	{
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
			injector.mapSingleton(UserUISession);
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
			signalCommandMap.mapSignalClass(AuthenticationSignal, AuthenticationCommand);
			signalCommandMap.mapSignalClass(ShareMicrophoneSignal, ShareMicrophoneCommand);
			signalCommandMap.mapSignalClass(ShareCameraSignal, ShareCameraCommand);
			signalCommandMap.mapSignalClass(LoadSlideSignal, LoadSlideCommand);
			signalCommandMap.mapSignalClass(CameraQualitySignal, CameraQualityCommand);
			signalCommandMap.mapSignalClass(DisconnectUserSignal, DisconnectUserCommand);
			
			////////////////////
			// 3 PagesNavigatorConfig
			////////////////////
			mediatorMap.mapView(PagesNavigatorView, PagesNavigatorViewMediator);
			signalCommandMap.mapSignalClass(JoinMeetingSignal, JoinMeetingCommand);


			////////////////////
			// 6 LockSettingsConfig
			////////////////////
			mediatorMap.mapView(LockSettingsView, LockSettingsViewMediator);
			
			////////////////////
			// 9 VideoChatConfig
			////////////////////
			mediatorMap.mapView(VideoChatView, VideoChatViewMediator);

			////////////////////
			// 10 ProfileConfig
			////////////////////
			mediatorMap.mapView(ProfileView, ProfileViewMediator);
			signalCommandMap.mapSignalClass(MoodSignal, MoodCommand);

			////////////////////
			// 14 StatusConfig
			////////////////////
			mediatorMap.mapView(StatusView, StatusViewMediator);
			signalCommandMap.mapSignalClass(MoodSignal, MoodCommand);

			////////////////////
			// 17 UserDetaisConfig
			////////////////////
			mediatorMap.mapView(UserDetaisView, UserDetaisViewMediator);
			signalCommandMap.mapSignalClass(ClearUserStatusSignal, ClearUserStatusCommand);
			signalCommandMap.mapSignalClass(PresenterSignal, PresenterCommand);
			signalCommandMap.mapSignalClass(ChangeRoleSignal, ChangeRoleCommand);
			signalCommandMap.mapSignalClass(LockUserSignal, LockUserCommand);

			////////////////////
			// 18 ParticipantsConfig
			////////////////////
//			mediatorMap.mapView(ParticipantsView, ParticipantsViewMediator);
			
			////////////////////
			// 19 SelectParticipantConfig
			////////////////////
			mediatorMap.mapView(SelectParticipantView, SelectParticipantViewMediator);
			
			////////////////////
			// 20 MicButtonConfig
			////////////////////
			mediatorMap.mapView(MicButton, MicButtonMediator);
			signalCommandMap.mapSignalClass(MicrophoneMuteSignal, MicrophoneMuteCommand);

			////////////////////
			// 21 VideoButtonConfig
			////////////////////
			mediatorMap.mapView(VideoButton, VideoButtonMediator);
			signalCommandMap.mapSignalClass(ShareCameraSignal, ShareCameraCommand);
			
			////////////////////
			// 22 NavigationButtonConfig
			////////////////////
			mediatorMap.mapView(NavigationButton, NavigationButtonMediator);
			signalCommandMap.mapSignalClass(NavigateToSignal, NavigateToCommand);

			////////////////////
			// 24 ExitPageConfig
			////////////////////
			mediatorMap.mapView(ExitPageView, ExitPageViewMediator);
			
			////////////////////
			// 25 DisconnectPageConfig
			////////////////////
			mediatorMap.mapView(DisconnectPageView, DisconnectPageViewMediator);
			
			////////////////////
			// 26 GuestPageConfig
			////////////////////
			mediatorMap.mapView(GuestPageView, GuestPageViewMediator);
			
			////////////////////
			// 28 RecordingStatusConfig
			////////////////////
			mediatorMap.mapView(RecordingStatus, RecordingStatusMediator);
			
			
			////////////////////
			// 31 MenuButtonsConfig
			////////////////////
			mediatorMap.mapView(MenuButtonsView, MenuButtonsViewMediator);
			
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