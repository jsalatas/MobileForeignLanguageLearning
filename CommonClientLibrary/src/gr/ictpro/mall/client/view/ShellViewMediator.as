package gr.ictpro.mall.client.view
{
	import mx.core.IVisualElement;
	import mx.managers.FocusManager;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.model.DetailView;
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.model.ParameterizedView;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import org.robotlegs.mvcs.Mediator;
	
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
		
		private function handleAddView(module:IVisualElement, parameters:Object=null, backView:IVisualElement = null):void
		{
			loadedModules.unloadModule();
			if(module is ParameterizedView) {
				(module as ParameterizedView).parameters = parameters;
			}
			if(module is DetailView) {
				(module as DetailView).masterView = backView;
			}
			view.addElement(module);
		
		}
		
		private function handleConnectionError():void 
		{
			var connectionErrorPopup:PopupNotification = new PopupNotification();
			connectionErrorPopup.message = Translation.getTranslation("Cannot Connect to Server.");
			
			connectionErrorPopup.addEventListener(PopUpEvent.CLOSE, connectionErrorPopup_close);
			connectionErrorPopup.open(view, true);
		}
		
		private function connectionErrorPopup_close(evt:PopUpEvent):void
		{
			addView.dispatch(new ServerNameView());
		}
	}
	
}