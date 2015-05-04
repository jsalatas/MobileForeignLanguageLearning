package gr.ictpro.mall.client.model
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.utils.ByteArray;
	
	import gr.ictpro.mall.client.Icons;
	
	import mx.collections.ArrayList;
	import mx.events.CloseEvent;
	import mx.utils.Base64Decoder;
	
	import spark.components.Image;
	import spark.filters.ColorMatrixFilter;

	public class User extends EventDispatcher
	{
		private var _id:int;
		private var _username:String;
		private var _email:String;
		private var _roles:ArrayList;
		private var _menu:ArrayList;
		private var _name:String;
		private var _photo:Image;
		
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

		public function get username():String
		{
			return this._username;
		}

		[Bindable]
		public function get name():String
		{
			return this._name;
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
			_menu = new ArrayList();
			var o:Object;
			if(_roles.getItemIndex("Admin") != -1) {
				o = new Object();
				o.text = "Manage";
				o.image = null;
				o.view = null;
				o.type = null;
				o.isGroup = true;
				_menu.addItem(o);

				o = new Object();
				o.text = "Settings";
				o.image = Icons.icon_settings;
				o.image.filters = [color];

				o.view = "Settings";
				o.type = "internal";
				_menu.addItem(o);

				o = new Object();
				o.text = "Profile";
				o.image = Icons.icon_profile;
				o.image.filters = [color];
				o.view = "Profile";
				o.type = "internal";
				_menu.addItem(o);

			}
			
			if(_roles.getItemIndex("Teacher") != -1) {
				
			}

			if(_roles.getItemIndex("Student") != -1) {
				
			}
			
			if(_roles.getItemIndex("Parent") != -1) {
				
			}
		}
	}
}