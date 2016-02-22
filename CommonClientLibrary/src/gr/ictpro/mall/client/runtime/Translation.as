package gr.ictpro.mall.client.runtime
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;

	[Bindable]
	[Bindable(event="translationChanged")]
	public class Translation extends EventDispatcher
	{
		private var _translations:ArrayCollection = new ArrayCollection();
		
		public function Translation()
		{
		}
		
		public function set translations(value:ArrayCollection):void
		{
			this._translations = value;
			dispatchEvent(new Event("translationChanged"));
		}
		
		
		public function getTranslation(originalText:String, ... args):String
		{
			var res:String = StringUtil.substitute(originalText, args);
			
			return res;
		}
	}
}