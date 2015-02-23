package gr.ictpro.mall.client.view
{
	import flash.display.Loader;
	import flash.system.Security;
	
	import gr.ictpro.mall.client.controller.InitializeCommand;
	import gr.ictpro.mall.client.model.ServerMessage;
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.GetServerNameSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.LoginFailedSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.signal.ShowMainViewSignal;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.modules.IModuleInfo;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.PopUpEvent;
	import spark.modules.Module;
	import spark.modules.ModuleLoader;
	
	public class ShellMediator extends Mediator
	{
		[Inject]
		public var view:ShellView;
		
		[Inject]
		public var getServerName:GetServerNameSignal;
			
		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var initialize:InitializeSignal;
		
		[Inject]
		public var showMainView:ShowMainViewSignal;

		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		override public function onRegister():void
		{
			showMainView.add(handleShowMainView);
			getServerName.add(handleShowGetServerName);
			addView.add(handleAddView);
			serverConnectError.add(handleConnectionError);
			
			initialize.dispatch();
		}
		
		private function handleAddView(module:IVisualElement):void
		{
			view.addElement(module);
		}
		
		private function handleShowGetServerName():void
		{
			var getServerNameView:GetServerNameView = new GetServerNameView();
			view.addElement(getServerNameView);
		}
	
		private function handleShowMainView(user:User):void
		{
			var mainView:MainView = new MainView();
			view.addElement(mainView);
			mainView.user = user;
		}
		
		private function handleConnectionError():void 
		{
			var connectionErrorPopup:Notification = new Notification();
			connectionErrorPopup.message = "Cannot connect to server.";
			
			connectionErrorPopup.addEventListener(PopUpEvent.CLOSE, connectionErrorPopup_close);
			connectionErrorPopup.open(view, true);
		}
		
		private function connectionErrorPopup_close(evt:PopUpEvent):void
		{
			getServerName.dispatch();
		}
	}
	
}