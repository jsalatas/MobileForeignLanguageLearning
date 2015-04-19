package gr.ictpro.mall.client.model
{
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.events.CloseEvent;
	import mx.utils.Base64Decoder;
	
	import spark.components.Image;

	public class User extends EventDispatcher
	{
		private var _id:int;
		private var _username:String;
		private var _email:String;
		private var _name:String;
		private var _photo:Image;
		
		[Embed(source="/assets/images/profile.png")]
		public static var DefaultProfileImage:Class;
		
		public function User(id:int, username:String, email:String, name:String, photo:String)
		{
			this._id = id;
			this._username = username;
			this._name = name;
			this._email = email;
			this._photo = new Image();
			if(photo == null) {
				var b:Bitmap = new DefaultProfileImage() as Bitmap;
				this._photo.source = b.bitmapData;
			} else {
				var d:Base64Decoder = new Base64Decoder();
				d.decode(photo);
				var b:Bitmap = new Bitmap();
				var r=new Rectangle(0,0, 150, 200);
				b.bitmapData.setPixels(r, d.toByteArray());
				this._photo.source = b.bitmapData;
			}
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

	}
}