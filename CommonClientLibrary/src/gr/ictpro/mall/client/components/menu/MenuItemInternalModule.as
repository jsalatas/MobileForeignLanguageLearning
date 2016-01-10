package gr.ictpro.mall.client.components.menu
{
	public class MenuItemInternalModule extends MenuItemIcon
	{
		private var _classType:Class;
		public function MenuItemInternalModule(text:String, icon:Object, classType:Class)
		{
			super(text, icon);
			this._classType = classType;
		}
		
		public function get classType():Class
		{
			return this._classType;
		}
	}
}