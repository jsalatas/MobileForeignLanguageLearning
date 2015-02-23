package gr.ictpro.mall.client.model
{
	public class AuthenticationDetails
	{
		private var _authenticationMethod:String;
		private var _username:String;
		private var _credentials:Object;
		
		public function AuthenticationDetails(authenticationMethod: String, username:String, credentials:Object)
		{
			this._authenticationMethod = authenticationMethod;
			this._username = username;
			this._credentials = credentials;
		}
		
		public function get username():String
		{
			return this._username;
		}
		public function get credentials():Object
		{
			return this._credentials;
		}
		public function get authenticationMethod():String
		{
			return this._authenticationMethod;
		}
	}
}