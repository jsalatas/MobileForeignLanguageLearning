package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.TopBarListView;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	
	public class ClassroomsViewMediator extends TopBarListViewMediator
	{
		override public function onRegister():void
		{
			super.onRegister();
			
			view.title = Translation.getTranslation("Classrooms");
			setBuildParametersHandler(buildDetailParameters);
			setDetailViewClass(ClassroomView);
			setGetNewHandler(getNew);
			
			var ro:RemoteObjectService = new RemoteObjectService(channel, "classroomRemoteService", "getClassrooms", null, handleGetClassrooms, getClassroomsError); 
		}
		
		private function handleGetClassrooms(event:ResultEvent):void
		{
			var classrooms:ArrayCollection = new ArrayCollection();
			var items:ArrayCollection = ArrayCollection(event.result);
			for(var i:int=0; i<items.length; i++) {
				var o:Object = new ObjectProxy(items.getItemAt(i));
				classrooms.addItem(o);
			}
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name")];
			classrooms.sort = sort;
			classrooms.refresh();
			
			TopBarListView(view).data = classrooms;
		}
		
		private function getClassroomsError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation("Cannot Get Classrooms."));
		}

		private function buildDetailParameters(classroom:Object): ObjectProxy
		{
			var parameters:ObjectProxy = new ObjectProxy();
			parameters.classroom = classroom;
			var classrooms:ArrayList = new ArrayList();
			for (var i:int = 0; i< TopBarListView(view).data.length; i++) {
				classrooms.addItem(TopBarListView(view).data.getItemAt(i).name + " (" + TopBarListView(view).data.getItemAt(i).languageCode +")");
			}
			parameters.classrooms = classrooms; 
			if(view.parameters != null && view.parameters.hasOwnProperty('notification')) {
				parameters.notification = Object(view.parameters.notification); 
			}
			return parameters;
		}

		private function getNew():ObjectProxy
		{
			var classroom:ObjectProxy = new ObjectProxy();
			classroom.id = null;
			classroom.name = "";
			classroom.notes = "";
			
			return classroom;
		}	

	}
}