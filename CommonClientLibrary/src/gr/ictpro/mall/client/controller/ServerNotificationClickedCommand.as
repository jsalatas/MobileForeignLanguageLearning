package gr.ictpro.mall.client.controller
{
	import flash.utils.getDefinitionByName;
	
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.model.vo.Notification;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ServerNotificationClickedCommand extends SignalCommand
	{
		[Inject]
		public var selectedNotification:Notification;

		[Inject]
		public var addView:AddViewSignal;
		

		override public function execute():void
		{
			if(selectedNotification.internalModule) {
				var p: ViewParameters = new ViewParameters();
				p.initParams = selectedNotification.parameters!= null? JSON.parse(selectedNotification.parameters.toString()): null;
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