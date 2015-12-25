package gr.ictpro.mall.client.utils.ui
{
	import mx.core.UIComponent;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.runtime.Translation;

	public class UI
	{
		public function UI()
		{
		}
		
		public static function getElementById(component:UIComponent, elementId:String):UIComponent
		{
			var res:UIComponent = null;
			for(var i:int=0; i<component.numChildren; i++) {
				if(component.getChildAt(i) is UIComponent ) {
					var child:UIComponent = UIComponent(component.getChildAt(i));
					if(child.id == elementId) {
						res = child;
						break;
					}
				}
			}
			
			return res; 
		}
		
		public static function showError(parent:UIComponent, message:String, closeHandler:Function=null):void
		{
			var popup:PopupNotification = new PopupNotification();
			popup.message = Translation.getTranslation(message);
			if(closeHandler != null) {
				popup.addEventListener(PopUpEvent.CLOSE, closeHandler);
			}
			popup.open(parent, true);

		}

	}
}