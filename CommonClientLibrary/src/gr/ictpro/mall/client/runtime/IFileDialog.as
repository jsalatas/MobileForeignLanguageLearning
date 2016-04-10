package gr.ictpro.mall.client.runtime
{
	import flash.events.IEventDispatcher;
	
	public interface IFileDialog extends IEventDispatcher
	{
		function browseForSave(title:String, filename:String=null, path:String=null):void;
		function browseForOpen(title:String, typeFilter:Array=null):void
		
	}
}