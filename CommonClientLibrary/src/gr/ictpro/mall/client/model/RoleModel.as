package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Role;
	import gr.ictpro.mall.client.runtime.Translation;

	public class RoleModel extends AbstractModel implements IServerPersistent
	{
		public function RoleModel()
		{
			super(Role, null);
		}
		
		public function get saveErrorMessage():String
		{
			throw new Error("Save operation not permitted in Role objects");
		}
		
		public function get deleteErrorMessage():String
		{
			throw new Error("Delete operation not permitted in Role objects");
		}
		
		public function get listErrorMessage():String
		{
			return Translation.getTranslation("Cannot Get Roles.");
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}
		
		public function get destination():String
		{
			return "authenticationRemoteService";
		}
		
		public function get saveMethod():String
		{
			throw new Error("Save operation not permitted in Role objects");
		}
		
		public function get deleteMethod():String
		{
			throw new Error("Delete operation not permitted in Role objects");
		}
		
		public function get listMethod():String
		{
			return "getRoles";
		}
	}
}