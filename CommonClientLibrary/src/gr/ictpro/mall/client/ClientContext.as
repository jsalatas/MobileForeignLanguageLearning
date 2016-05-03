package gr.ictpro.mall.client
{
	import gr.ictpro.mall.client.components.DetailTab;
	import gr.ictpro.mall.client.components.DetailTabMediator;
	import gr.ictpro.mall.client.components.TopBarCollaborationView;
	import gr.ictpro.mall.client.components.TopBarView;
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.controller.DeleteCommand;
	import gr.ictpro.mall.client.controller.GenericServiceCommand;
	import gr.ictpro.mall.client.controller.GetTranslationsCommand;
	import gr.ictpro.mall.client.controller.InitializeCommand;
	import gr.ictpro.mall.client.controller.ListCommand;
	import gr.ictpro.mall.client.controller.LoginCommand;
	import gr.ictpro.mall.client.controller.LogoutCommand;
	import gr.ictpro.mall.client.controller.MenuClickedCommand;
	import gr.ictpro.mall.client.controller.RegisterCommand;
	import gr.ictpro.mall.client.controller.SaveCommand;
	import gr.ictpro.mall.client.controller.SendShapeCommand;
	import gr.ictpro.mall.client.controller.ServerNotificationClickedCommand;
	import gr.ictpro.mall.client.controller.ShowAuthenticationCommand;
	import gr.ictpro.mall.client.model.CalendarModel;
	import gr.ictpro.mall.client.model.ClassroomModel;
	import gr.ictpro.mall.client.model.ClassroomgroupModel;
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.model.ConfigModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.MeetingModel;
	import gr.ictpro.mall.client.model.MeetingTypeModel;
	import gr.ictpro.mall.client.model.NotificationModel;
	import gr.ictpro.mall.client.model.RoleModel;
	import gr.ictpro.mall.client.model.ScheduleModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.LoadedSWFs;
	import gr.ictpro.mall.client.service.LocalDBStorage;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.DeleteErrorSignal;
	import gr.ictpro.mall.client.signal.DeleteSignal;
	import gr.ictpro.mall.client.signal.DeleteSuccessSignal;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.GetTranslationsSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.LogoutSignal;
	import gr.ictpro.mall.client.signal.MenuChangedSignal;
	import gr.ictpro.mall.client.signal.MenuClickedSignal;
	import gr.ictpro.mall.client.signal.MessageReceivedSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveErrorSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	import gr.ictpro.mall.client.signal.SendShapeSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationClickedSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowErrorSignal;
	import gr.ictpro.mall.client.view.BBBMeetingView;
	import gr.ictpro.mall.client.view.BBBMeetingViewMediator;
	import gr.ictpro.mall.client.view.CalendarDayView;
	import gr.ictpro.mall.client.view.CalendarDayViewMediator;
	import gr.ictpro.mall.client.view.CalendarMonthView;
	import gr.ictpro.mall.client.view.CalendarMonthViewMediator;
	import gr.ictpro.mall.client.view.CalendarView;
	import gr.ictpro.mall.client.view.CalendarViewMediator;
	import gr.ictpro.mall.client.view.ClassroomView;
	import gr.ictpro.mall.client.view.ClassroomViewMediator;
	import gr.ictpro.mall.client.view.ClassroomgroupView;
	import gr.ictpro.mall.client.view.ClassroomgroupViewMediator;
	import gr.ictpro.mall.client.view.ClassroomgroupsView;
	import gr.ictpro.mall.client.view.ClassroomgroupsViewMediator;
	import gr.ictpro.mall.client.view.ClassroomsView;
	import gr.ictpro.mall.client.view.ClassroomsViewMediator;
	import gr.ictpro.mall.client.view.LanguageView;
	import gr.ictpro.mall.client.view.LanguageViewMediator;
	import gr.ictpro.mall.client.view.LanguagesView;
	import gr.ictpro.mall.client.view.LanguagesViewMediator;
	import gr.ictpro.mall.client.view.MainView;
	import gr.ictpro.mall.client.view.MainViewMediator;
	import gr.ictpro.mall.client.view.MeetingView;
	import gr.ictpro.mall.client.view.MeetingViewMediator;
	import gr.ictpro.mall.client.view.MeetingsView;
	import gr.ictpro.mall.client.view.MeetingsViewMediator;
	import gr.ictpro.mall.client.view.ServerNameView;
	import gr.ictpro.mall.client.view.ServerNameViewMediator;
	import gr.ictpro.mall.client.view.SettingsView;
	import gr.ictpro.mall.client.view.SettingsViewMediator;
	import gr.ictpro.mall.client.view.ShellView;
	import gr.ictpro.mall.client.view.ShellViewMediator;
	import gr.ictpro.mall.client.view.UserView;
	import gr.ictpro.mall.client.view.UserViewMediator;
	import gr.ictpro.mall.client.view.UsersView;
	import gr.ictpro.mall.client.view.UsersViewMediator;
	import gr.ictpro.mall.client.view.components.TranslationManagerComponent;
	import gr.ictpro.mall.client.view.components.TranslationManagerComponentMediator;
	import gr.ictpro.mall.client.view.components.bbb.ChatView;
	import gr.ictpro.mall.client.view.components.bbb.ChatViewMediator;
	import gr.ictpro.mall.client.view.components.bbb.MeetingSettingsView;
	import gr.ictpro.mall.client.view.components.bbb.MeetingSettingsViewMediator;
	import gr.ictpro.mall.client.view.components.bbb.ParticipantsView;
	import gr.ictpro.mall.client.view.components.bbb.ParticipantsViewMediator;
	import gr.ictpro.mall.client.view.components.bbb.VideoView;
	import gr.ictpro.mall.client.view.components.bbb.VideoViewMediator;
	import gr.ictpro.mall.client.view.components.bbb.WhiteboardView;
	import gr.ictpro.mall.client.view.components.bbb.WhiteboardViewMediator;
	
	import org.bigbluebutton.Context;
	
	public class ClientContext extends Context
	{
//		public function getInjector():IInjector
//		{
//			return injector;
//		}
			
		override public function startup():void
		{
			super.startup();
			injector.mapSingleton(AddViewSignal);
			injector.mapSingleton(LoginFailedSignal);
			injector.mapSingleton(LoginSuccessSignal);
			injector.mapSingleton(RegisterFailedSignal);
			injector.mapSingleton(RegisterSuccessSignal);
			injector.mapSingleton(SaveErrorSignal);
			injector.mapSingleton(SaveSuccessSignal);
			injector.mapSingleton(DeleteErrorSignal);
			injector.mapSingleton(DeleteSuccessSignal);
			injector.mapSingleton(ListErrorSignal);
			injector.mapSingleton(ListSuccessSignal);
			injector.mapSingleton(ServerConnectErrorSignal);
			injector.mapSingleton(ServerMessageReceivedSignal);
			injector.mapSingleton(GenericCallErrorSignal);
			injector.mapSingleton(GenericCallSuccessSignal);
			injector.mapSingleton(ShowErrorSignal);
			injector.mapSingleton(MessageReceivedSignal);
			injector.mapSingleton(MenuChangedSignal);

			
			injector.mapSingleton(MessagingService);
			injector.mapSingleton(Channel);
			injector.mapSingleton(RuntimeSettings);
			injector.mapSingleton(MainMenu);
			injector.mapSingleton(AuthenticationProviders);
			injector.mapSingleton(LoadedSWFs);
			injector.mapSingleton(LocalDBStorage);
			
			injector.mapSingleton(VOMapper);
			injector.mapSingleton(ClassroomModel);
			injector.mapSingleton(ClassroomgroupModel);
			injector.mapSingleton(ConfigModel);
			injector.mapSingleton(LanguageModel);
			injector.mapSingleton(NotificationModel);
			injector.mapSingleton(RoleModel);
			injector.mapSingleton(UserModel);
			injector.mapSingleton(ClientSettingsModel);
			injector.mapSingleton(CalendarModel);
			injector.mapSingleton(ScheduleModel);
			injector.mapSingleton(MeetingModel);
			injector.mapSingleton(MeetingTypeModel);

			
			mediatorMap.mapView(ShellView, ShellViewMediator);
			mediatorMap.mapView(ServerNameView, ServerNameViewMediator);
			mediatorMap.mapView(MainView, MainViewMediator);
			mediatorMap.mapView(SettingsView, SettingsViewMediator, TopBarView);
			mediatorMap.mapView(UserView, UserViewMediator, TopBarView);
			mediatorMap.mapView(LanguagesView, LanguagesViewMediator, TopBarView);
			mediatorMap.mapView(LanguageView, LanguageViewMediator, TopBarView);
			mediatorMap.mapView(ClassroomsView, ClassroomsViewMediator, TopBarView);
			mediatorMap.mapView(ClassroomView, ClassroomViewMediator, TopBarView);
			mediatorMap.mapView(ClassroomgroupsView, ClassroomgroupsViewMediator, TopBarView);
			mediatorMap.mapView(ClassroomgroupView, ClassroomgroupViewMediator, TopBarView);
			mediatorMap.mapView(CalendarMonthView, CalendarMonthViewMediator, TopBarView);
			mediatorMap.mapView(CalendarDayView, CalendarDayViewMediator, TopBarView);
			mediatorMap.mapView(CalendarView, CalendarViewMediator, TopBarView);
			mediatorMap.mapView(UsersView, UsersViewMediator, TopBarView);
			mediatorMap.mapView(MeetingView, MeetingViewMediator, TopBarView);
			mediatorMap.mapView(MeetingsView, MeetingsViewMediator, TopBarView);
			mediatorMap.mapView(BBBMeetingView, BBBMeetingViewMediator, TopBarCollaborationView);
			mediatorMap.mapView(WhiteboardView, WhiteboardViewMediator);
			mediatorMap.mapView(ParticipantsView, ParticipantsViewMediator);
			mediatorMap.mapView(ChatView, ChatViewMediator);
			mediatorMap.mapView(VideoView, VideoViewMediator);
			mediatorMap.mapView(MeetingSettingsView, MeetingSettingsViewMediator);
			
			mediatorMap.mapView(TranslationManagerComponent, TranslationManagerComponentMediator);
			mediatorMap.mapView(DetailTab, DetailTabMediator);
			
			
			signalCommandMap.mapSignalClass(InitializeSignal, InitializeCommand);
			signalCommandMap.mapSignalClass(ShowAuthenticationSignal, ShowAuthenticationCommand);
			signalCommandMap.mapSignalClass(LoginSignal, LoginCommand);
			signalCommandMap.mapSignalClass(LogoutSignal, LogoutCommand);
			signalCommandMap.mapSignalClass(RegisterSignal, RegisterCommand);
			signalCommandMap.mapSignalClass(MenuClickedSignal, MenuClickedCommand);
			signalCommandMap.mapSignalClass(ServerNotificationClickedSignal, ServerNotificationClickedCommand);
			signalCommandMap.mapSignalClass(SaveSignal, SaveCommand);
			signalCommandMap.mapSignalClass(DeleteSignal, DeleteCommand);
			signalCommandMap.mapSignalClass(ListSignal, ListCommand);
			signalCommandMap.mapSignalClass(GenericCallSignal, GenericServiceCommand);
			signalCommandMap.mapSignalClass(GetTranslationsSignal, GetTranslationsCommand);
			signalCommandMap.mapSignalClass(SendShapeSignal, SendShapeCommand);

			Device.settings = injector.getInstance(RuntimeSettings);
			
			// Initialize the models
			injector.getInstance(ClassroomModel);
			injector.getInstance(ClassroomgroupModel);
			injector.getInstance(ConfigModel);
			injector.getInstance(LanguageModel);
			injector.getInstance(NotificationModel);
			injector.getInstance(RoleModel);
			injector.getInstance(UserModel);
			injector.getInstance(ClientSettingsModel);
			injector.getInstance(CalendarModel);
			injector.getInstance(ScheduleModel);
			injector.getInstance(MeetingModel);
			injector.getInstance(MeetingTypeModel);

		}
	}
}