package gr.ictpro.mall.client.model
{
	public class User
	{
		private var _id:int;
		private var _username:String;
		private var _email:String;
		private var _name:String;
		
		public function User(id:int, username:String, email:String, name:String)
		{
			this._id = id;
			this._username = username;
			this._name = name;
			this._email = email;
		}
		
		public function get id():int
		{
			return this._id;
		}
		 
		public function get email():String
		{
			return this._email;
		}

		public function get username():String
		{
			return this._username;
		}

		public function get name():String
		{
			return this._name;
		}
	}
}