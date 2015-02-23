package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.SavePropertySignal;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class GetServerNameMediator extends Mediator
	{
		[Inject]
		public var view:GetServerNameView;
		
		[Inject]
		public var saveProperty:SavePropertySignal;

		[Inject]
		public var initialize:InitializeSignal;

		override public function onRegister():void
		{
			view.okClicked.add(handleOK);
		}
		
		protected function handleOK():void
		{
			var property:Object = new Object();
			property.name = Settings.SERVER_URL;
			property.value = view.serverName.text;
			saveProperty.dispatch(property);

			property = new Object();
			property.name = Settings.APP_PATH;
			property.value = view.applicationPath.text;
			saveProperty.dispatch(property);

			property = new Object();
			property.name = Settings.MODULES_PATH;
			property.value = view.modulesPath.text;
			saveProperty.dispatch(property);
			view.dispose();
			
			initialize.dispatch();
		}
		
	}
	
	
}