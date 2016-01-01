package gr.ictpro.mall.client.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import spark.components.Group;
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.Icons;
	import gr.ictpro.mall.client.components.PopUpMenu;
	import gr.ictpro.mall.client.components.menu.MenuItemCommand;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.IPersistent;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.model.vo.Profile;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.service.AuthenticationProvider;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	import gr.ictpro.mall.client.utils.image.ImageTransform;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	import jp.shichiseki.exif.IFD;
	
	public class UserViewMediator extends TopBarDetailViewMediator
	{
		private static var GET_USER:String = "getUser";

		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;

		[Inject]
		public var saveSuccess:SaveSuccessSignal;

		[Inject]
		public function set userModel(model:UserModel):void
		{
			super.model = model as AbstractModel;
		}
		

		private var photoUrl:String = "";
		private var bitmap:Bitmap = null; 
		
		override public function onRegister():void
		{
			super.onRegister();
			
			addToSignal(saveSuccess, saveSuccessHandler);
			
			if(view.parameters == null || (view.parameters != null && view.parameters.initParams == null && view.parameters.vo == null)) {
				view.title = Translation.getTranslation("My Profile");
				view.disableDelete(); // user cannot delete her own profile
				if(view.parameters == null) {
					view.parameters = new ViewParameters();
				}
				view.parameters.vo = settings.user;
				view.currentState = "profile";
			} else if(view.parameters.initParams.hasOwnProperty("user_id")) {
				view.currentState = "edit";
				view.title = Translation.getTranslation("Edit User");
				getUser(view.parameters.initParams.user_id);
			} else if(view.parameters.vo != null) {
				view.currentState = "view";
				view.title = User(view.parameters.vo).username;
				view.disableDelete();
				view.disableOK();
				view.disableCancel();
			} else {
				throw new Error("Unknown User");
			}
			
			addToSignal(UserView(view).choosePhoto, choosePhotoHandler);
		}
		
		
		private function getUser(id:int):void
		{
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = new Object();
			args.arguments.id = id;
			args.destination = "userRemoteService";
			args.method = "getUser";
			args.type = GET_USER;
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);

		}
		
		private function success(type:String, result:Object):void
		{
			if(type == GET_USER) {
				removeSignals();
				if(result != null) {
					view.parameters.vo = result;
				} else {
					UI.showError(view,Translation.getTranslation("Cannot get User"));
					back();
				}
			}
		}
		
		private function error(type:String, event:FaultEvent):void
		{
			if(type == GET_USER) {
				removeSignals();
				UI.showError(view,Translation.getTranslation("Cannot get User"));
				back();
			}
		}
		
		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}
		
		override protected function beforeSaveHandler():void
		{
			var user:User = User(view.parameters.vo);
			var userView:UserView = UserView(view);
			user.email = userView.txtEmail.text;
			user.profile.name = userView.txtName.text;
			//user.profile.photo = ByteArray(userView.imgPhoto.source);
			user.profile.image = userView.imgPhoto;
			user.profile.color = userView.popupColor.selected;
			if(view.currentState == "edit") {
				user.enabled = userView.chkEnabled.selected;
			}
		}
		
		override protected function validateSave():Boolean
		{
			if(UserView(view).txtPassword.text != "" || UserView(view).txtPassword2.text != "") {
				if(UserView(view).txtPassword.text != UserView(view).txtPassword2.text) {
					UI.showError(view,Translation.getTranslation("Passwords do not Match"));
					return false;
				} else {
					User(view.parameters.vo).password = UserView(view).txtPassword.text; 
				}
			}
			return true;
		}
		

		private function saveSuccessHandler(classType:Class):void
		{
			if(classType == User) {
				if(view.parameters == null) {
					// user edited his own profile
					settings.user = User(view.parameters.vo);
				}
			}
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

		private function getPhotoOptions():ArrayCollection
		{
			var res:ArrayCollection = new ArrayCollection();
			if(CameraRoll.supportsBrowseForImage) {
				res.addItem(new MenuItemCommand(Translation.getTranslation("Choose Photo"), Icons.icon_folder, Device.defaultColorTransform, openGallery));
			}
			
			if(CameraUI.isSupported) {
				res.addItem(new MenuItemCommand(Translation.getTranslation("Take New Photo"), Icons.icon_camera, Device.defaultColorTransform, capturePhoto));
			}
		
			if(res.length == 0) {
				// We assume that ther application is running on the desktop. 
				// Show the open file dialog in order to select photo from disk
				res.addItem(new MenuItemCommand(Translation.getTranslation("Choose Photo"), Icons.icon_folder, Device.defaultColorTransform, chooseFile));
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
			UserView(view).imgPhoto.source = croppedImage;
			
			
		}
	}
	
}