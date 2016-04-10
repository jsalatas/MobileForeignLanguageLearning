package gr.ictpro.mall.client.desktop.components
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	import gr.ictpro.mall.client.runtime.FileSelectEvent;
	import gr.ictpro.mall.client.runtime.IFileDialog;
	
	public class DesktopFileDialog extends EventDispatcher implements IFileDialog
	{
		public function DesktopFileDialog(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function browseForSave(title:String, filename:String=null, path:String=null):void
		{
			var f:File;
			if(path == null && filename == null) {
				f = new File();
			} else if(path != null && filename != null) {
				f = new File(path + File.separator + filename);
			} else if(path == null && filename != null) {
				f = new File(File.documentsDirectory.nativePath + File.separator + filename);
			} else if(path != null && filename == null) {
				f = new File(File.documentsDirectory.nativePath);
			}
			
			f.addEventListener(Event.SELECT, select);
			f.browseForSave(title);
		}
		
		public function browseForOpen(title:String, typeFilter:Array=null):void
		{
			var f:File = new File();
			f.addEventListener(Event.SELECT, select);
			f.browseForOpen(title, typeFilter);
		}
		
		private function select(e:Event):void {
			var event:FileSelectEvent = new FileSelectEvent(FileSelectEvent.FILE_SELECT, File(e.target));

			dispatchEvent(event);
		}
	}
}