package gr.ictpro.mall.client.components.menu
{
	public class MenuItemGroup extends MenuItem
	{
		
		public function MenuItemGroup(text:String)
		{
			super(text);
		}
		
		override public function get isGroup():Boolean
		{
			return true;
		}

	}
}