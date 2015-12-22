package gr.ictpro.mall.client
{
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.components.TopBarListView;
	import gr.ictpro.mall.client.components.TopBarView;
	import gr.ictpro.mall.client.controller.InitializeCommand;
	import gr.ictpro.mall.client.controller.LoginCommand;
	import gr.ictpro.mall.client.controller.MenuCommand;
	import gr.ictpro.mall.client.controller.RegisterCommand;
	import gr.ictpro.mall.client.controller.SavePropertyCommand;
	import gr.ictpro.mall.client.controller.ServerNotificationCommand;
	import gr.ictpro.mall.client.controller.ServerNotificationHandledCommand;
	import gr.ictpro.mall.client.controller.ShowAuthenticationCommand;
	import gr.ictpro.mall.client.controller.ShowRegistrationCommand;
	import gr.ictpro.mall.client.controller.UpdateServerNotificationsCommand;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Device;
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.service.RegistrationProviders;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.MenuSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.SavePropertySignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationHandledSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowErrorSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	import gr.ictpro.mall.client.signal.UpdateServerNotificationsSignal;
	import gr.ictpro.mall.client.view.ClassroomView;
	import gr.ictpro.mall.client.view.ClassroomViewMediator;
	import gr.ictpro.mall.client.view.ClassroomsView;
	import gr.ictpro.mall.client.view.ClassroomsViewMediator;
	import gr.ictpro.mall.client.view.LanguageView;
	import gr.ictpro.mall.client.view.LanguageViewMediator;
	import gr.ictpro.mall.client.view.LanguagesView;
	import gr.ictpro.mall.client.view.LanguagesViewMediator;
	import gr.ictpro.mall.client.view.MainView;
	import gr.ictpro.mall.client.view.MainViewMediator;
	import gr.ictpro.mall.client.view.ServerNameView;
	import gr.ictpro.mall.client.view.ServerNameViewMediator;
	import gr.ictpro.mall.client.view.SettingsView;
	import gr.ictpro.mall.client.view.SettingsViewMediator;
	import gr.ictpro.mall.client.view.ShellView;
	import gr.ictpro.mall.client.view.ShellViewMediator;
	import gr.ictpro.mall.client.view.UserView;
	import gr.ictpro.mall.client.view.UserViewMediator;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.core.IModule;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class ClientContext extends ModuleContext
	{
		public function getInjector():IInjector
		{
			return injector;
		}
			
		override public function startup():void
		{
			viewMap.mapType(IModule);
			injector.mapSingleton(AddViewSignal);
			injector.mapSingleton(LoginFailedSignal);
			injector.mapSingleton(LoginSuccessSignal);
			injector.mapSingleton(RegisterFailedSignal);
			injector.mapSingleton(RegisterSuccessSignal);
			injector.mapSingleton(ServerConnectErrorSignal);
			injector.mapSingleton(ServerMessageReceivedSignal);
			injector.mapSingleton(ShowErrorSignal);
			injector.mapSingleton(Modules);
			injector.mapSingleton(MessagingService);
			injector.mapSingleton(Channel);
			injector.mapSingleton(Settings);
			injector.mapSingleton(AuthenticationProviders);
			injector.mapSingleton(RegistrationProviders);
			
			mediatorMap.mapView(ShellView, ShellViewMediator);
			mediatorMap.mapView(ServerNameView, ServerNameViewMediator);
			mediatorMap.mapView(MainView, MainViewMediator);
			mediatorMap.mapView(SettingsView, SettingsViewMediator, TopBarView);
			mediatorMap.mapView(UserView, UserViewMediator, TopBarView);
			mediatorMap.mapView(LanguagesView, LanguagesViewMediator, TopBarView);
			mediatorMap.mapView(LanguageView, LanguageViewMediator, TopBarView);
			mediatorMap.mapView(ClassroomsView, ClassroomsViewMediator, TopBarView);
			mediatorMap.mapView(ClassroomView, ClassroomViewMediator, TopBarView);
			
			signalCommandMap.mapSignalClass(InitializeSignal, InitializeCommand);
			signalCommandMap.mapSignalClass(SavePropertySignal, SavePropertyCommand);
			signalCommandMap.mapSignalClass(ShowAuthenticationSignal, ShowAuthenticationCommand);
			signalCommandMap.mapSignalClass(LoginSignal, LoginCommand);
			signalCommandMap.mapSignalClass(RegisterSignal, RegisterCommand);
			signalCommandMap.mapSignalClass(ShowRegistrationSignal, ShowRegistrationCommand);
			signalCommandMap.mapSignalClass(MenuSignal, MenuCommand);
			signalCommandMap.mapSignalClass(ServerNotificationSignal, ServerNotificationCommand);
			signalCommandMap.mapSignalClass(UpdateServerNotificationsSignal, UpdateServerNotificationsCommand);
			signalCommandMap.mapSignalClass(ServerNotificationHandledSignal, ServerNotificationHandledCommand);

			Device.settings = injector.getInstance(Settings);
		}
	}
}