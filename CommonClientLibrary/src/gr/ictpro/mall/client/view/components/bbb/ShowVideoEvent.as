package gr.ictpro.mall.client.view.components.bbb
{
	import flash.events.Event;
	
	import org.bigbluebutton.model.User;
	
	public class ShowVideoEvent extends Event
	{
		public static const SHOW_VIDEO:String = "videoClicked";
		
		public var user:User;
		
		public function ShowVideoEvent(type:String, user:User, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.user = user;
		}
	}
}