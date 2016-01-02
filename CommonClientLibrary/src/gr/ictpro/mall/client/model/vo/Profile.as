package gr.ictpro.mall.client.model.vo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import assets.fxg.profile;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.components.Image;
	import gr.ictpro.mall.client.runtime.Device;
	
	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.Profile")]
	public class Profile
	{
		public var userId:Number;
		public var name:String;
		public var photo:ByteArray;
		public var color:int;
		[Transient]
		private var _image:Image;
		
		public function Profile()
		{
		}
		
		public function toString():String
		{
			return name;
		}
		
		[Transient]
		public function get image():Image
		{
			if(_image == null) {
				_image = new Image(); 
				if(photo == null) {
					_image.source = Icons.icon_defaultProfile;
					this._image.transform.colorTransform = Device.defaultColorTransform;
				} else {
					var ba:ByteArray = photo;
					var width:int= ba.readInt();
					var heigth:int = ba.readInt();
					var bmd:ByteArray = new ByteArray();
					ba.readBytes(bmd);
					var bd:BitmapData = new BitmapData(width, heigth);
					bd.setPixels(new Rectangle(0,0, width, heigth), bmd);
					var b:Bitmap = new Bitmap();
					b.bitmapData = bd;
					this._image.source = b.bitmapData;
				}
			}
			
			return _image;
		}
		
		public function set image(image:Image):void
		{
			_image = image;
			if(image.source is profile) {
				// This is the default image. Don't save it in database
				photo = null;
			} else {
				var bd:BitmapData = (image.source as BitmapData);
				var b:ByteArray = new ByteArray(); 
				b.writeInt(bd.width);
				b.writeInt(bd.height);
				var bmd:ByteArray =bd.getPixels(new Rectangle(0, 0, bd.width, bd.height)); 
				b.writeBytes(bmd); 
				photo = b;
			}
		}

	}
}