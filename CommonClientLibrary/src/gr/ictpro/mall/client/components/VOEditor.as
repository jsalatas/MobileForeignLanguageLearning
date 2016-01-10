package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.runtime.Device;

	public class VOEditor extends Group
	{
		[Bindable]
		public var vo:Object;

		public function VOEditor()
		{
			super();
			
			maxWidth=Device.isAndroid?NaN:500;
		}
		
		
		public function set state(state:String):void {
			currentState = state;
		}

	}
}