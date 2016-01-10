package gr.ictpro.mall.client.mobile.skins
{
	import spark.components.ButtonBarButton;
	import spark.components.DataGroup;
	import spark.components.supportClasses.ButtonBarHorizontalLayout;
	import spark.skins.mobile.ButtonBarSkin;
	import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
	
	public class ButtonBarSkin extends spark.skins.mobile.ButtonBarSkin
	{
		public function ButtonBarSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			// Set up the class factories for the buttons
			if (!firstButton)
			{
				firstButton = new ButtonBarButtonClassFactory(ButtonBarButton);
				firstButton.skinClass = ButtonBarButtonSkin;
			}
			
			if (!lastButton)
			{
				lastButton = new ButtonBarButtonClassFactory(ButtonBarButton);
				lastButton.skinClass = ButtonBarButtonSkin;
			}
			
			if (!middleButton)
			{
				middleButton = new ButtonBarButtonClassFactory(ButtonBarButton);
				middleButton.skinClass = ButtonBarButtonSkin;
			}
			
			// create the data group to house the buttons
			if (!dataGroup)
			{
				dataGroup = new DataGroup();
				var hLayout:ButtonBarHorizontalLayout = new ButtonBarHorizontalLayout();
				hLayout.gap = -1;
				dataGroup.layout = hLayout;
				addChild(dataGroup);
			}
		}

	}
}