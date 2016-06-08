package gr.ictpro.mall.client.service
{
	import flash.events.Event;
	
	public class MovieLoadedEvent extends Event
	{
		public static const LOADED:String = "classLoaded";
		public var loadedClass:Class; 
		public function MovieLoadedEvent(type:String, loadedClass:Class, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.loadedClass = loadedClass;
		}
	}
}