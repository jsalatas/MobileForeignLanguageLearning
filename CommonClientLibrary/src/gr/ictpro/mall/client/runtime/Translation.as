package gr.ictpro.mall.client.runtime
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import gr.ictpro.mall.client.model.vo.UITranslation;

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
			var translatedText:String = originalText;
			var found:Boolean = false;
			for each(var t:UITranslation in _translations) {
				if (t.originalText == originalText) {
					translatedText = t.translatedText;
					found = true;
					break;
				}
			}
			
			
			var res:String = StringUtil.substitute(translatedText, args);
			
			if(!found) {
				trace(">>>>>>>>>>>>>>> Translation missing: " + originalText);
			}
			return res;
		}
	}
}