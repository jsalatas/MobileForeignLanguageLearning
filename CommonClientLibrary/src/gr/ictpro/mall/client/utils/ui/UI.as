package gr.ictpro.mall.client.utils.ui
{
	import mx.core.UIComponent;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.runtime.Device;

	public class UI
	{
		private static var sho
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
		
		public static function showError(message:String, closeHandler:Function=null):void
		{
			var popup:PopupNotification = new PopupNotification();
			popup.type = PopupNotification.TYPE_ERROR;
			popup.message = Device.translations.getTranslation(message);
			if(closeHandler != null) {
				popup.addEventListener(PopUpEvent.CLOSE, closeHandler);
			}
			popup.open(Device.shellView, true);
		}

		public static function showInfo(message:String, closeHandler:Function=null):void
		{
			var popup:PopupNotification = new PopupNotification();
			popup.type = PopupNotification.TYPE_INFO;
			popup.message = Device.translations.getTranslation(message);
			if(closeHandler != null) {
				popup.addEventListener(PopUpEvent.CLOSE, closeHandler);
			}
			popup.open(Device.shellView, true);
		}

	}
}