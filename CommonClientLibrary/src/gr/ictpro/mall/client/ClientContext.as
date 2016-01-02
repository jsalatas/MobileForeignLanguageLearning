package gr.ictpro.mall.client
{
	import gr.ictpro.mall.client.components.TopBarView;
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.controller.DeleteCommand;
	import gr.ictpro.mall.client.controller.GenericServiceCommand;
	import gr.ictpro.mall.client.controller.InitializeCommand;
	import gr.ictpro.mall.client.controller.ListCommand;
	import gr.ictpro.mall.client.controller.LoginCommand;
	import gr.ictpro.mall.client.controller.MenuClickedCommand;
	import gr.ictpro.mall.client.controller.RegisterCommand;
	import gr.ictpro.mall.client.controller.SaveCommand;
	import gr.ictpro.mall.client.controller.SavePropertyCommand;
	import gr.ictpro.mall.client.controller.ServerNotificationClickedCommand;
	import gr.ictpro.mall.client.controller.ShowAuthenticationCommand;
	import gr.ictpro.mall.client.controller.ShowRegistrationCommand;
	import gr.ictpro.mall.client.model.ClassroomModel;
	import gr.ictpro.mall.client.model.ClassroomgroupModel;
	import gr.ictpro.mall.client.model.ConfigModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.NotificationModel;
	import gr.ictpro.mall.client.model.RoleModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.LoadedSWFs;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.service.RegistrationProviders;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.DeleteErrorSignal;
	import gr.ictpro.mall.client.signal.DeleteSignal;
	import gr.ictpro.mall.client.signal.DeleteSuccessSignal;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.LoginSignal;
	import gr.ictpro.mall.client.signal.LoginSuccessSignal;
	import gr.ictpro.mall.client.signal.MenuClickedSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveErrorSignal;
	import gr.ictpro.mall.client.signal.SavePropertySignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationClickedSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowErrorSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
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
	import gr.ictpro.mall.client.view.ServerNameView;
	import gr.ictpro.mall.client.view.ServerNameViewMediator;
	import gr.ictpro.mall.client.view.SettingsView;
	import gr.ictpro.mall.client.view.SettingsViewMediator;
	import gr.ictpro.mall.client.view.ShellView;
	import gr.ictpro.mall.client.view.ShellViewMediator;
	import gr.ictpro.mall.client.view.UserView;
	import gr.ictpro.mall.client.view.UserViewMediator;
	import gr.ictpro.mall.client.view.components.TranslationManagerComponent;
	import gr.ictpro.mall.client.view.components.TranslationManagerComponentMediator;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class ClientContext extends ModuleContext
	{
		public function getInjector():IInjector
		{
			return injector;
		}
			
		override public function startup():void
		{
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

			
			injector.mapSingleton(MessagingService);
			injector.mapSingleton(Channel);
			injector.mapSingleton(RuntimeSettings);
			injector.mapSingleton(MainMenu);
			injector.mapSingleton(AuthenticationProviders);
			injector.mapSingleton(RegistrationProviders);
			injector.mapSingleton(LoadedSWFs);
			
			injector.mapSingleton(VOMapper);
			injector.mapSingleton(ClassroomModel);
			injector.mapSingleton(ClassroomgroupModel);
			injector.mapSingleton(ConfigModel);
			injector.mapSingleton(LanguageModel);
			injector.mapSingleton(NotificationModel);
			injector.mapSingleton(RoleModel);
			injector.mapSingleton(UserModel);

			
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
			
			mediatorMap.mapView(TranslationManagerComponent, TranslationManagerComponentMediator);
			
			
			signalCommandMap.mapSignalClass(InitializeSignal, InitializeCommand);
			signalCommandMap.mapSignalClass(SavePropertySignal, SavePropertyCommand);
			signalCommandMap.mapSignalClass(ShowAuthenticationSignal, ShowAuthenticationCommand);
			signalCommandMap.mapSignalClass(LoginSignal, LoginCommand);
			signalCommandMap.mapSignalClass(RegisterSignal, RegisterCommand);
			signalCommandMap.mapSignalClass(ShowRegistrationSignal, ShowRegistrationCommand);
			signalCommandMap.mapSignalClass(MenuClickedSignal, MenuClickedCommand);
			signalCommandMap.mapSignalClass(ServerNotificationClickedSignal, ServerNotificationClickedCommand);
			signalCommandMap.mapSignalClass(SaveSignal, SaveCommand);
			signalCommandMap.mapSignalClass(DeleteSignal, DeleteCommand);
			signalCommandMap.mapSignalClass(ListSignal, ListCommand);
			signalCommandMap.mapSignalClass(GenericCallSignal, GenericServiceCommand);

			Device.settings = injector.getInstance(RuntimeSettings);
			
			// Initialize the models
			injector.getInstance(ClassroomModel);
			injector.getInstance(ClassroomgroupModel);
			injector.getInstance(ConfigModel);
			injector.getInstance(LanguageModel);
			injector.getInstance(NotificationModel);
			injector.getInstance(RoleModel);
			injector.getInstance(UserModel);

		}
	}
}