package gr.ictpro.mall.client.model.menu
{
	public class MenuItemSelected
	{
		private var _menuItem:MenuItem;
		public function MenuItemSelected(menuItem:MenuItem)
		{
			this._menuItem = menuItem;
		}
		
		public function get menuItem():MenuItem
		{
			return this._menuItem;
		}
	}
}