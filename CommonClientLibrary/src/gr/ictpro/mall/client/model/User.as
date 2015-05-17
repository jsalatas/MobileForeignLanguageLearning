package gr.ictpro.mall.client.model
{
	import assets.fxg.profile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.utils.ByteArray;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.menu.MainMenu;
	
	import mx.collections.ArrayList;
	import mx.events.CloseEvent;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	import spark.components.Image;
	import spark.filters.ColorMatrixFilter;

	public class User extends EventDispatcher implements IServerPersistentObject
	{
		private var _id:int;
		private var _username:String;
		private var _email:String;
		private var _roles:ArrayList;
		private var _menu:ArrayList;
		private var _name:String;
		private var _photo:Image;
		
		public static function createUser(o:Object):User {
			var name:String;
			var photo:String;
			if(o.profile == null) {
				name = o.username;
				photo = null;
			} else {
				name = o.profile.name;
				photo = o.photo;
			}
			
			var roles:ArrayList = new ArrayList();
			for each (var role:Object in o.roles) {
				roles.addItem(role.role);
			}
			var u:User = new User(o.id, o.username, o.email, roles, name, photo);
			return u;
		}
		
		public function User(id:int, username:String, email:String, roles:ArrayList, name:String, photo:String)
		{
			this._id = id;
			this._username = username;
			this._name = name;
			this._roles = roles;
			this._email = email;
			this._photo = new Image();
			var b:Bitmap;
			if(photo == null) {
				this._photo.source = Icons.icon_defaultProfile;
				
				var matrix:Array = new Array();
				matrix = matrix.concat([1, 0, 0, 0, 0]); // red
				matrix = matrix.concat([0, 1, 0, 0, 0]); // green
				matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
				matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
				var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
				this._photo.source.filters = [filter];
			} else {
				var d:Base64Decoder = new Base64Decoder();
				d.decode(photo);
				b = new Bitmap();
				var r:Rectangle=new Rectangle(0,0, 150, 200);
				b.bitmapData.setPixels(r, d.toByteArray());
				this._photo.source = b.bitmapData;
			}
			
			initializeMenu();
		}
		
		public function get color():ColorMatrixFilter 
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([0, 0, 0, 0, 0]); // red
			matrix = matrix.concat([0, 0, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, 0, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return filter;
		}
		
		public function get id():int
		{
			return this._id;
		}
		 
		public function get email():String
		{
			return this._email;
		}

		public function set email(email:String):void
		{
			this._email = email;
		}

		public function get username():String
		{
			return this._username;
		}

		[Bindable]
		public function get name():String
		{
			return this._name;
		}

		public function get roles():ArrayList
		{
			return this._roles;
		}

		public function set name(name:String):void
		{
			this._name = name;
		}

		[Bindable]
		public function get photo():Object
		{
			return this._photo.source;
		}

		public function set photo(source:Object):void
		{
			this._photo.source = source;
		}
		
		public function getMenu():ArrayList
		{
			return this._menu;
		}

		private function initializeMenu():void
		{
			this._menu = MainMenu.getMenu(this);
		}
		
		public function get persistentData():PersistentData 
		{
			var p:PersistentData = new PersistentData();
			p.addValue("id", _id);
			p.addValue("username", _username);
			p.addValue("email", _email);
			p.addValue("roles", _roles);
			p.addValue("name", _name);
			if(_photo.source is profile) {
				// This is the default image. Don't save it in database
				p.addValue("photo", null);
			} else {
				var e:Base64Encoder = new Base64Encoder();
				p.addValue("photo", e.encodeBytes((_photo.source as BitmapData).getPixels(new Rectangle(0,0, 150, 200))));
			}
			
			return p;
			
		}

		public function get destination():String 
		{
			return "userRemoteService";
		}
		
		public function get methodName():String {
			return "save";
		}

	}
}