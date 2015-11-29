package gr.ictpro.mall.client.utils.ui
{
	import mx.core.UIComponent;

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

	}
}