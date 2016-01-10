package gr.ictpro.mall.client.components.menu
{

	public class MenuItemExternalModule extends MenuItemIcon
	{
		private var _moduleName:String;
		public function MenuItemExternalModule(text:String, icon:Object, moduleName:String)
		{
			super(text, icon);
			this._moduleName = moduleName;
		}
	}
}