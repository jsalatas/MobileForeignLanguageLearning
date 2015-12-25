package gr.ictpro.mall.client.controller
{
	import flash.utils.getDefinitionByName;
	
	import mx.utils.ObjectProxy;
	
	import gr.ictpro.mall.client.service.Modules;
	import gr.ictpro.mall.client.model.ServerNotification;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ServerNotificationCommand extends SignalCommand
	{
		[Inject]
		public var selectedNotification:ServerNotification;

		[Inject]
		public var loadedModules:Modules;
		
		[Inject]
		public var addView:AddViewSignal;
		

		override public function execute():void
		{
			if(selectedNotification.isInternalModule) {
				loadedModules.module = null;
				var p:ObjectProxy = new ObjectProxy();
				p.initParams = selectedNotification.parameters;
				p.notification = selectedNotification;
				addView.dispatch(createInstance(selectedNotification.module), p);
			} else {
				//TODO: load external module
			}
		}
		
		public function createInstance(className:String):Object
		{
			var myClass:Class = getDefinitionByName(className) as Class;
			var instance:Object = new myClass();
			return instance;
		}

	}
	

}