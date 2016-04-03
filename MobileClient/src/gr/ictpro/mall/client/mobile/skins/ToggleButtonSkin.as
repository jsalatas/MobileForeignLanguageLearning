package gr.ictpro.mall.client.mobile.skins
{
	import mx.core.DPIClassification;

	public class ToggleButtonSkin extends ButtonSkin
	{
		public function ToggleButtonSkin()
		{
			super();
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					measuredDefaultWidth = 44; //Device.getScaledSize(100);
					measuredDefaultHeight = 44; //Device.getScaledSize(22);
					minWidth= 44; //Device.getScaledSize(100);
					minHeight = 44; //Device.getScaledSize(22);
					break;
				}
				case DPIClassification.DPI_240:
				{
					measuredDefaultWidth = 33; //Device.getScaledSize(100);
					measuredDefaultHeight = 33; //Device.getScaledSize(22);
					minWidth= 33; //Device.getScaledSize(100);
					minHeight = 33; //Device.getScaledSize(22);			
					break;
				}
				default:
				{
					// default PPI160
					measuredDefaultWidth = 22; //Device.getScaledSize(100);
					measuredDefaultHeight = 22; //Device.getScaledSize(22);
					minWidth= 22; //Device.getScaledSize(100);
					minHeight = 22; //Device.getScaledSize(22);			
					break;
				}
			}

		}
	}
}