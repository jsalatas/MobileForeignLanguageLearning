package gr.ictpro.mall.client.view
{
	import flash.display.Loader;
	import flash.system.Security;
	
	import gr.ictpro.mall.client.controller.InitializeCommand;
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.model.ServerMessage;
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.signal.ServerMessageReceivedSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.modules.IModuleInfo;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.PopUpEvent;
	import spark.modules.Module;
	import spark.modules.ModuleLoader;
	import gr.ictpro.mall.client.components.PopupNotification;
	
	public class ShellViewMediator extends Mediator
	{
		[Inject]
		public var view:ShellView;
		
		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var initialize:InitializeSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		[Inject]
		public var loadedModules:Modules;

		override public function onRegister():void
		{
			addView.add(handleAddView);
			serverConnectError.add(handleConnectionError);
			
			initialize.dispatch();
		}
		
		private function handleAddView(module:IVisualElement):void
		{
			loadedModules.unloadModule();
			view.addElement(module);
		}
		
		private function handleConnectionError():void 
		{
			var connectionErrorPopup:PopupNotification = new PopupNotification();
			connectionErrorPopup.message = "Cannot connect to server.";
			
			connectionErrorPopup.addEventListener(PopUpEvent.CLOSE, connectionErrorPopup_close);
			connectionErrorPopup.open(view, true);
		}
		
		private function connectionErrorPopup_close(evt:PopUpEvent):void
		{
			addView.dispatch(new ServerNameView());
		}
	}
	
}