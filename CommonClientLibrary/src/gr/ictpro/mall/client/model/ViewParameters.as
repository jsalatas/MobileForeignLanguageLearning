package gr.ictpro.mall.client.model
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectProxy;
	
	import gr.ictpro.mall.client.model.vo.Notification;

	[Bindable]
	public class ViewParameters extends ObjectProxy
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