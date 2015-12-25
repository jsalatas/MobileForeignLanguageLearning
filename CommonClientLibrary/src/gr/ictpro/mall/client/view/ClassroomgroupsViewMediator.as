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
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class ClassroomgroupsViewMediator extends TopBarListViewMediator
	{
		override public function onRegister():void
		{
			super.onRegister();
			
			view.title = Translation.getTranslation("Classroom Groups");
			setBuildParametersHandler(buildDetailParameters);
			setDetailViewClass(ClassroomgroupView);
			setGetNewHandler(getNew);
			
			var ro:RemoteObjectService = new RemoteObjectService(channel, "classroomRemoteService", "getClassroomgroups", null, handleGetClassroomgroups, getClassroomgroupsError); 
		}

		private function handleGetClassroomgroups(event:ResultEvent):void
		{
			var classroomgroups:ArrayCollection = new ArrayCollection();
			var items:ArrayCollection = ArrayCollection(event.result);
			for(var i:int=0; i<items.length; i++) {
				var o:Object = new ObjectProxy(items.getItemAt(i));
				classroomgroups.addItem(o);
			}
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name")];
			classroomgroups.sort = sort;
			classroomgroups.refresh();
			
			TopBarListView(view).data = classroomgroups;
		}
		
		private function getClassroomgroupsError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation("Cannot Get Classroom Groups."));
		}

		private function getNew():ObjectProxy
		{
			var classroomgroup:ObjectProxy = new ObjectProxy();
			classroomgroup.id = null;
			classroomgroup.name = "";
			classroomgroup.notes = "";
			
			return classroomgroup;
		}	
		
		private function buildDetailParameters(classroomgroup:Object): ObjectProxy
		{
			var parameters:ObjectProxy = new ObjectProxy();
			parameters.classroomgroup = classroomgroup;

			if(view.parameters != null && view.parameters.hasOwnProperty('notification')) {
				parameters.notification = Object(view.parameters.notification); 
			}
			
			return parameters;
		}


	}
}