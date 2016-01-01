package gr.ictpro.mall.client.components.menu
{
	import flash.geom.ColorTransform;

	public class MenuItemInternalModule extends MenuItemIcon
	{
		private var _classType:Class;
		public function MenuItemInternalModule(text:String, icon:Object, colorTransform:ColorTransform, classType:Class)
		{
			super(text, icon, colorTransform);
			this._classType = classType;
		}
		
		public function get classType():Class
		{
			return this._classType;
		}
	}
}