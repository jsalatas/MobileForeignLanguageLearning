package gr.ictpro.mall.client.model
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	
	import spark.components.Image;
	
	import assets.fxg.profile;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.model.menu.MainMenu;

	public class User extends EventDispatcher 
	{
		private var _id:int;
		private var _username:String;
		private var _email:String;
		private var _roles:ArrayList;
		private var _menu:ArrayList;
		private var _name:String;
		private var _photo:Image;
		private var _color:uint; 
		private var _notifications:ArrayList;
		private var _plainPassword:String;
		private var _enabled:Boolean;
		
		public static function createUser(o:Object):User {
			var name:String;
			var color:uint = 0x000066;
			
			var photo:BitmapData;
			if(o.profile == null) {
				name = o.username;
				photo = null;
			} else {
				name = o.profile.name;
				if(o.profile.hasOwnProperty("color")) {
					color = o.profile.color;
				}
				if(o.profile.photo != null) {
				var ba:ByteArray = o.profile.photo;
				var width:int= ba.readInt();
				var heigth:int = ba.readInt();
				var bmd:ByteArray = new ByteArray();
				ba.readBytes(bmd);
				var bd:BitmapData = new BitmapData(width, heigth);
				bd.setPixels(new Rectangle(0,0, width, heigth), bmd);
				photo = bd;
				}
			}
			
			var roles:ArrayList = new ArrayList();
			for each (var role:Object in o.roles) {
				roles.addItem(role.role);
			}
			var u:User = new User(o.id, o.username, o.email, roles, name, photo, color, o.enabled);
			return u;
		}
		
		public function User(id:int, username:String, email:String, roles:ArrayList, name:String, photo:BitmapData, color:uint, enabled:Boolean)
		{
			this._id = id;
			this._username = username;
			this._name = name;
			this._roles = roles;
			this._email = email;
			this._color = color;
			this._photo = new Image();
			this._enabled = enabled;
			var b:Bitmap;
			if(photo == null) {
				this._photo.source = Icons.icon_defaultProfile;
				
				this._photo.transform.colorTransform = Device.defaultColorTransform;
			} else {
				b = new Bitmap();
				b.bitmapData = photo;
				this._photo.source = b.bitmapData;
			}
			
			//initializeMenu();
		}
		
		public function get color():uint 
		{
			return this._color;
		}
		
		public function set color(color:uint):void 
		{
			this._color = color;
		}
		
		
		public function get id():int
		{
			return this._id;
		}
		 
		public function get email():String
		{
			return this._email;
		}

		[Bindable]
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
		
		public function set plainPassword(password:String):void
		{
			this._plainPassword = password;
		}
		
		public function get plainPassword():String
		{
			return this._plainPassword;
		}
		
		public function getMenu():ArrayList
		{
			return this._menu;
		}

		public function initializeMenu():void
		{
			this._menu = MainMenu.getMenu(this);
		}
		
		public function get enabled():Boolean
		{
			return this._enabled;
		}
		
		[Bindable]
		public function set enabled(enabled:Boolean):void
		{
			this._enabled = enabled;
		}

		public function get persistentData():Object 
		{
			var p:Object = new Object();
			p.id = _id;
			p.username = _username;
			p.email = _email;
			p.roles = _roles;
			p.name = _name;
			p.color = _color;
			p.enabled = _enabled;
			if(this.plainPassword != null) {
				p.password = _plainPassword;
			}
			if(_photo.source is profile) {
				// This is the default image. Don't save it in database
				p.photo = null;
			} else {
				var bd:BitmapData = (_photo.source as BitmapData);
				var b:ByteArray = new ByteArray(); 
				b.writeInt(bd.width);
				b.writeInt(bd.height);
				var bmd:ByteArray =bd.getPixels(new Rectangle(0, 0, bd.width, bd.height)); 
				b.writeBytes(bmd); 
				p.photo = b;
			}
			
			return p;
		}

		public function set notifications(notifications:ArrayList):void
		{
			this._notifications = notifications;
		}
		
		[Bindable]
		public function get notifications():ArrayList
		{
			return this._notifications;
		}
		
		public function get isAdmin():Boolean
		{
			return this._roles.getItemIndex("Admin") != -1;
		}

		public function get isTeacher():Boolean
		{
			return this._roles.getItemIndex("Teacher") != -1;
		}
		
		public function get isStudent():Boolean
		{
			return this._roles.getItemIndex("Student") != -1;
		}
		
		public function get isParent():Boolean
		{
			return this._roles.getItemIndex("Parent") != -1;
		}

	}
}