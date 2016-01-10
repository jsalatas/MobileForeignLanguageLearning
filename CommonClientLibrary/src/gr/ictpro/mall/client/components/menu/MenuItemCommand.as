package gr.ictpro.mall.client.components.menu
{
	public class MenuItemCommand extends MenuItemIcon
	{
		private var _command:Function;
		public function MenuItemCommand(text:String, icon:Object, command:Function)
		{
			super(text, icon);
			this._command = command;
		}
		
		public function execute():*
		{
			return this._command();
		}
	}
}