package gr.ictpro.mall.client.view
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.components.IDetailView;
	import gr.ictpro.mall.client.components.IParameterizedView;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.LogoutSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ShellViewMediator extends SignalMediator
	{
		[Inject]
		public var view:ShellView;
		
		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var logoutSignal:LogoutSignal;
		
		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var initialize:InitializeSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;

		override public function onRegister():void
		{
			addToSignal(addView, handleAddView);
			addToSignal(serverConnectError, handleConnectionError);
			initialize.dispatch();
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, closeApplication);
		}
		
		private function closeApplication(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, closeApplication);
			if(settings.user != null) {
				event.preventDefault();
				logoutSignal.dispatch();
			}
		}
		
		private function handleAddView(module:IVisualElement, parameters:ViewParameters=null, backView:IVisualElement = null):void
		{
			injector.injectInto(module);
			if(module is IParameterizedView) {
				(module as IParameterizedView).parameters = parameters;
			}
			if(module is IDetailView && backView != null) {
				(module as IDetailView).masterView = backView;
			}
			view.addElement(module);
		
		}
		
		private function handleConnectionError():void 
		{
			UI.showError("Cannot Connect to Server.", connectionErrorPopup_close);
		}

		private function connectionErrorPopup_close(evt:PopUpEvent):void
		{
			addView.dispatch(new ServerNameView());
		}
	}
	
}