package gr.ictpro.mall.client.desktop.skins
{
	import spark.skins.spark.ListSkin;
	
	public class ListSkin extends spark.skins.spark.ListSkin
	{
		public function ListSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			scroller.verticalScrollBar.setStyle("skinClass", VScrollBarSkin);
			scroller.horizontalScrollBar.setStyle("skinClass", HScrollBarSkin);
		}
	}
}