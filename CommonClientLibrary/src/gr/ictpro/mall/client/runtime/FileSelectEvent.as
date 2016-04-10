package gr.ictpro.mall.client.runtime
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class FileSelectEvent extends Event
	{
		public static const FILE_SELECT:String = "selectFile"; 
		public var file:File; 
		public function FileSelectEvent(type:String, file:File, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.file = file;
		}
	}
}