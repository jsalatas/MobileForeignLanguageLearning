package gr.ictpro.mall.client.model
{
	import flash.errors.IllegalOperationError;
	
	import gr.ictpro.mall.client.model.vo.Config;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.components.SettingsViewComponent;

	public class ConfigModel extends AbstractModel implements IServerPersistent
	{
		public function ConfigModel()
		{
			super(Config, null, SettingsViewComponent);
		}
		
		public function get deleteErrorMessage():String
		{
			//Not implemented
			throw new IllegalOperationError("Deleting Server Configuration is not permitted");
		}
		
		public function get listErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Get Server Configuration");
		}
		
		public function get saveErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Save Server Configuration");
		}
		
		public function get destination():String
		{
			return "configRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateConfig";
		}
		public function get deleteMethod():String
		{
			// Not implemented
			throw new IllegalOperationError("Deleting Server Configuration is not permitted");
		}
		
		public function get listMethod():String
		{
			return "getConfig";
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}

	}
}