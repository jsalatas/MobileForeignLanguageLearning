package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.utils.collections.ArrayUtils;
	import gr.ictpro.mall.client.view.UserView;
	import gr.ictpro.mall.client.view.components.UserComponent;

	public class UserModel extends AbstractModel implements IServerPersistent
	{
		[Inject]
		public var roleModel:RoleModel; 
		
		public function UserModel()
		{
			super(User, UserView, UserComponent);
		}
		
		public function get saveErrorMessage():String
		{
			return "Cannot Save User";
		}
		
		public function get deleteErrorMessage():String
		{
			return "Cannot Delete User";
		}
		
		public function get listErrorMessage():String
		{
			return "Cannot Get User";
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
			return "userRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "save";
		}
		
		public function get deleteMethod():String
		{
			return "deleteUser";
		}
		
		public function get listMethod():String
		{
			return "getUsers";
		}
		
		public static function isAdmin(user:User):Boolean
		{
			return ArrayUtils.getItemIndexByProperty(user.roles.source, "role", "Admin") != -1;
		}

		public static function isTeacher(user:User):Boolean
		{
			return ArrayUtils.getItemIndexByProperty(user.roles.source, "role", "Teacher") != -1;
		}

		public static function isStudent(user:User):Boolean
		{
			return ArrayUtils.getItemIndexByProperty(user.roles.source, "role", "Student") != -1;
		}
		
		public static function isParent(user:User):Boolean
		{
			return ArrayUtils.getItemIndexByProperty(user.roles.source, "role", "Parent") != -1;
		}

	}
}