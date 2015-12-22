package gr.ictpro.mall.client.view
{
	import mx.core.IVisualElement;
	import mx.utils.ObjectProxy;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.model.DetailView;
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.model.ParameterizedView;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
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
		
		private function handleAddView(module:IVisualElement, parameters:ObjectProxy=null, backView:IVisualElement = null):void
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
			UI.showError(view,Translation.getTranslation("Cannot Connect to Server."), connectionErrorPopup_close);
		}

		private function connectionErrorPopup_close(evt:PopUpEvent):void
		{
			addView.dispatch(new ServerNameView());
		}
	}
	
}