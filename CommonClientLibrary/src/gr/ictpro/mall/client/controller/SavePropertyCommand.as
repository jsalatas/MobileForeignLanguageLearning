package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.SavePropertySignal;
	import gr.ictpro.mall.client.service.Storage;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class SavePropertyCommand extends SignalCommand
	{
		[Inject]
		public var property:Object;
		
		override public function execute():void
		{
			Storage.saveSetting(property.name, property.value);
		}
	}
}