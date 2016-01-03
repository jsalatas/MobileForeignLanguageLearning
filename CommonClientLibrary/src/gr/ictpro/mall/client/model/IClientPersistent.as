package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.service.LocalDBStorage;

	public interface IClientPersistent extends IPersistent
	{
		function set dbStorage(dbStorage:LocalDBStorage):void;
		function initializeDB():void;
		function loadObjects():void;
		function saveObject(vo:Object):void;
		function deleteObject(vo:Object):void;

	}
}