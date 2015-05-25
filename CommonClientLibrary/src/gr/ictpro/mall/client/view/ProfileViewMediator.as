package gr.ictpro.mall.client.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.components.ImageCropper;
	import gr.ictpro.mall.client.components.PopUpMenu;
	import gr.ictpro.mall.client.model.DeviceType;
	import gr.ictpro.mall.client.model.IPersistentObject;
	import gr.ictpro.mall.client.model.PersistentData;
	import gr.ictpro.mall.client.model.PersistentObjectWrapper;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.model.menu.MenuItemCommand;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.PersistSignal;
	import gr.ictpro.mall.client.utils.image.ImageTransform;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	import jp.shichiseki.exif.IFD;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Application;
	import spark.components.Group;
	import spark.events.PopUpEvent;
	
	public class ProfileViewMediator extends Mediator
	{
		[Inject]
		public var view:ProfileView;
		
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var settings:Settings;
		
		[Inject]
		public var persist:PersistSignal;
		
		private var photoUrl:String = "";
		private var bitmap:Bitmap = null; 
		
		
		override public function onRemove():void
		{
			trace("Removed");
		}
		override public function onRegister():void
		{
			view.user = settings.user;
			view.save.add(saveHandler);
			view.cancel.add(cancelHandler);
			view.back.add(backHandler);
			view.choosePhoto.add(choosePhotoHandler);
		}
		
		private function saveHandler():void
		{
			settings.user.name = view.txtName.text;
			settings.user.photo = view.imgPhoto.source;
			settings.user.email = view.txtEmail.text;
			persist.dispatch(new PersistentObjectWrapper(settings.user, persistSuccessHandler, persistErrorHandler));
		}
		
		private function cancelHandler():void
		{
			backHandler();
		}

		private function backHandler():void
		{
			view.save.removeAll();
			view.cancel.removeAll();
			view.back.removeAll();
			view.dispose();
			addView.dispatch(new MainView());
		}
		
		private function persistSuccessHandler(event:Event):void
		{
			var o:Object = (event as ResultEvent).result;
			settings.user = User.createUser(o);
			view.user = settings.user;
			backHandler();
		}

		private function persistErrorHandler(event:FaultEvent):void
		{
			var saveErrorPopup:Notification = new Notification();
			saveErrorPopup.message = "Cannot Save Profile.";
			
			saveErrorPopup.open(view, true);
		}
		
		private function choosePhotoHandler(event:MouseEvent):void
		{
			var popup:PopUpMenu = new PopUpMenu();
			popup.menuList = getPhotoOptions();

			var curDensity:Number = FlexGlobals.topLevelApplication.runtimeDPI; 
			var curAppDPI:Number = FlexGlobals.topLevelApplication.applicationDPI; 
			
			popup.x = event.stageX *curAppDPI/curDensity;
			popup.y = event.stageY *curAppDPI/curDensity;
			popup.percentWidth = 100;
			popup.itemSelected.add(popUpAction);
			popup.addEventListener(PopUpEvent.CLOSE, popUpClose);
			popup.open(view, false);

		}
		
		private function popUpClose(event:PopUpEvent):void
		{
			photoUrl = "";
			bitmap = null;
			(event.currentTarget as PopUpMenu).itemSelected.removeAll();
		}
		
		private function popUpAction(selected:MenuItemCommand):void
		{
			selected.execute();
		}
		
		private function openGallery():void
		{
			var cameraRoll:CameraRoll = new CameraRoll();
			cameraRoll.addEventListener(MediaEvent.SELECT, cameraPhotoHandler);
			cameraRoll.addEventListener(Event.CANCEL, onCancel);
			cameraRoll.addEventListener(ErrorEvent.ERROR, onError);
			cameraRoll.browseForImage();

		}

		private function chooseFile():void
		{
			var file:File = File.documentsDirectory;
			file.addEventListener(Event.SELECT, fileSelectHandler); 
			var imgFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png");
			file.browseForOpen("Choose photo", [imgFilter]);
		}

		private function capturePhoto():void
		{
			var cameraUI:CameraUI = new CameraUI();
			cameraUI.launch(MediaType.IMAGE);
			cameraUI.addEventListener(MediaEvent.COMPLETE, cameraPhotoHandler);
			cameraUI.addEventListener(Event.CANCEL, onCancel);
			cameraUI.addEventListener(ErrorEvent.ERROR, onError);
		}

		private function getPhotoOptions():ArrayList
		{
			var res:ArrayList = new ArrayList();
			if(CameraRoll.supportsBrowseForImage) {
				res.addItem(new MenuItemCommand("Choose Photo", Icons.icon_folder, settings.user.color, openGallery));
			}
			
			if(CameraUI.isSupported) {
				res.addItem(new MenuItemCommand("Take New Photo", Icons.icon_camera, settings.user.color, capturePhoto));
			}
		
			if(res.length == 0) {
				// We assume that ther application is running on the desktop. 
				// Show the open file dialog in order to select photo from disk
				res.addItem(new MenuItemCommand("Choose Photo", Icons.icon_folder, settings.user.color, chooseFile));
			}
			
			return res;
		}
		
		private function onCancel(event:Event):void {
			trace("user left the Gallery", event.type);
		}
		
		private function onError(event:Event):void {
			trace("Gallery error", event.type);
		}
		
		
		private function fileSelectHandler(event:Event):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			photoUrl = (event.target as File).nativePath;
			loader.load(new URLRequest((event.target as File).nativePath));
		}

		private function cameraPhotoHandler(event:MediaEvent):void {
			var promise:MediaPromise = event.data as MediaPromise;
			photoUrl = promise.file.url;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.loadFilePromise(promise);
		}
		
		private function onImageLoaded(event:Event):void {
			bitmap = event.currentTarget.content as Bitmap;
			getExif();
		}
		
		private function getExif():void
		{
			var loader:ExifLoader = new ExifLoader();
			loader.addEventListener(Event.COMPLETE, onExifLoaded);
			loader.load(new URLRequest(photoUrl));
		}
		
		private function onExifLoaded(event:Event):void
		{
			var orientation:int = getOrientation((event.currentTarget as ExifLoader).exif);
			var bitmapData:BitmapData = ImageTransform.transform(bitmap.bitmapData, orientation);
			
			var imageCropperView:ImageCropperView = new ImageCropperView();
			imageCropperView.image = bitmapData;
			imageCropperView.ok.add(applyCropHandler);
			(view.parent as Group).addElement(imageCropperView);

		}
		
		private function getOrientation(exifInfo:ExifInfo):int
		{
			if(exifInfo == null || exifInfo.ifds == null) 
				return -1;
			
			var exifData:Object = new Object;
			this.iterateTags(exifInfo.ifds.primary, exifData);
			this.iterateTags(exifInfo.ifds.exif, exifData);
			this.iterateTags(exifInfo.ifds.gps, exifData);
			this.iterateTags(exifInfo.ifds.interoperability, exifData);
			this.iterateTags(exifInfo.ifds.thumbnail, exifData);

			if(exifData.hasOwnProperty("Orientation")) {
				return exifData.Orientation;
			}
			return -1;
		}
		
		private function iterateTags(ifd:IFD, exifData:Object):void
		{
			if (!ifd) return;
			for (var entry:String in ifd)
			{
				if (entry == "MakerNote") continue;
				exifData[entry] = ifd[entry];
			}
		}

		
		private function applyCropHandler(croppedImage:BitmapData):void {
			trace("Image Cropped");
			view.imgPhoto.source = croppedImage;
			
			
		}
	}
	
}