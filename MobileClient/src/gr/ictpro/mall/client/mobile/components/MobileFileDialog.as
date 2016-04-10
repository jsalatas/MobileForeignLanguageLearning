package gr.ictpro.mall.client.mobile.components
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.components.Button;
	import gr.ictpro.mall.client.mobile.components.FileDialog;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.FileSelectEvent;
	import gr.ictpro.mall.client.runtime.IFileDialog;
	
	public class MobileFileDialog extends EventDispatcher implements IFileDialog
	{
		public function MobileFileDialog(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function browseForSave(title:String, filename:String=null, path:String=null):void
		{
			var currentDir:File = null;
			if(path == null) {
				currentDir = File.documentsDirectory;
			} else {
				currentDir = new File(path);
			}
			
			dialog = new FileDialog();
			dialog.currentState = "save";
			dialog.title = title;
			dialog.currentDir = currentDir;
			dialog.currentFile = filename;
			dialog.open(Device.shellView, true);
			dialog.btnOk.addEventListener(MouseEvent.CLICK, select);
			dialog.addEventListener(PopUpEvent.CLOSE, dialogClose);
		}

		public function dialogClose(e:PopUpEvent):void {
			var dialog:FileDialog = FileDialog(e.currentTarget);
			dialog.btnOk.removeEventListener(MouseEvent.CLICK, select);
		}

		private var dialog:FileDialog; 
		public function browseForOpen(title:String, typeFilter:Array=null):void
		{
			var currentDir:File = File.documentsDirectory;
			dialog = new FileDialog();
			dialog.currentState = "open";
			dialog.title = title;
			dialog.typeFilter = typeFilter;
			dialog.currentDir = currentDir;
			dialog.open(Device.shellView, true);
			dialog.addEventListener(PopUpEvent.CLOSE, closeHandler);
			dialog.btnOk.addEventListener(MouseEvent.CLICK, select);
			
		}
		
		private function closeHandler(e:PopUpEvent):void {
			dialog.removeEventListener(PopUpEvent.CLOSE, closeHandler);
			dialog.btnOk.removeEventListener(MouseEvent.CLICK, select);
			dialog = null;
		}
		
		private function select(e:Event):void {
			var f:File;
			if(dialog.currentState == "save") {
				f=dialog.currentDir.resolvePath(dialog.txtFilename.text);
			} else {
				f= dialog.fileList.selectedItem;
			}
			
			dialog.close();
			var event:FileSelectEvent = new FileSelectEvent(FileSelectEvent.FILE_SELECT, f);
			dispatchEvent(event); 
		}
	}
}