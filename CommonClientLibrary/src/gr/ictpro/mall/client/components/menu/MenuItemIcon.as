package gr.ictpro.mall.client.components.menu
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class MenuItemIcon extends MenuItem
	{
		private var _icon:Object;
		
		public function MenuItemIcon(text:String, icon:Object, colorTransform:ColorTransform)
		{
			super(text);
			this._icon = icon;
			(this._icon as DisplayObject).transform.colorTransform = colorTransform;
		}
		
		public function get icon():Object
		{
			return this._icon;
		}
	}
}