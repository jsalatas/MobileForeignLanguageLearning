package gr.ictpro.mall.client
{
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	
	import gr.ictpro.mall.client.controller.InitializeCommand;
	import gr.ictpro.mall.client.controller.LoginCommand;
	import gr.ictpro.mall.client.controller.MenuCommand;
	import gr.ictpro.mall.client.controller.RegisterCommand;
	import gr.ictpro.mall.client.controller.SavePropertyCommand;
	import gr.ictpro.mall.client.controller.ShowAuthenticationCommand;
	import gr.ictpro.mall.client.controller.ShowRegistrationCommand;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.service.RegistrationProviders;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.GetServerNameSignal;
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
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowMainViewSignal;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	import gr.ictpro.mall.client.view.GetServerNameMediator;
	import gr.ictpro.mall.client.view.GetServerNameView;
	import gr.ictpro.mall.client.view.MainView;
	import gr.ictpro.mall.client.view.MainViewMediator;
	import gr.ictpro.mall.client.view.ShellMediator;
	import gr.ictpro.mall.client.view.ShellView;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.core.IModule;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class ClientContext extends ModuleContext
	{
		override public function startup():void
		{
			viewMap.mapType(IModule);
			injector.mapSingleton(GetServerNameSignal);
			injector.mapSingleton(AddViewSignal);
			injector.mapSingleton(LoginFailedSignal);
			injector.mapSingleton(LoginSuccessSignal);
			injector.mapSingleton(RegisterFailedSignal);
			injector.mapSingleton(RegisterSuccessSignal);
			injector.mapSingleton(ServerConnectErrorSignal);
			injector.mapSingleton(ServerMessageReceivedSignal);
			injector.mapSingleton(ShowMainViewSignal);
			injector.mapSingleton(Modules);
			injector.mapSingleton(MessagingService);
			injector.mapSingleton(Channel);
			injector.mapSingleton(Settings);
			injector.mapSingleton(AuthenticationProviders);
			injector.mapSingleton(RegistrationProviders);
			
			mediatorMap.mapView(ShellView, ShellMediator);
			mediatorMap.mapView(GetServerNameView, GetServerNameMediator);
			mediatorMap.mapView(MainView, MainViewMediator);
			
			signalCommandMap.mapSignalClass(InitializeSignal, InitializeCommand);
			signalCommandMap.mapSignalClass(SavePropertySignal, SavePropertyCommand);
			signalCommandMap.mapSignalClass(ShowAuthenticationSignal, ShowAuthenticationCommand);
			signalCommandMap.mapSignalClass(LoginSignal, LoginCommand);
			signalCommandMap.mapSignalClass(RegisterSignal, RegisterCommand);
			signalCommandMap.mapSignalClass(ShowRegistrationSignal, ShowRegistrationCommand);
			signalCommandMap.mapSignalClass(MenuSignal, MenuCommand);
		}
	}
}