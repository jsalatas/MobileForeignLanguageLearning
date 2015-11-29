package gr.ictpro.mall.client.model
{
	public dynamic class PersistentData  
	{
		public function PersistentData()
		{
			super();
		}
		
		public function addValue(name:String, value: *): void
		{
			this[name] = value;
		}
		
			
	}
}