package gr.ictpro.mall.client.model
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import gr.ictpro.mall.client.model.vo.Notification;

	[Bindable]
	public class ViewParameters
	{
		public var vo:Object;
		public var initParams:Object;
		public var notification:Notification;
		
		public function getVOClass():Class
		{
			return Class(getDefinitionByName(getQualifiedClassName(vo)));
		}
	}
}