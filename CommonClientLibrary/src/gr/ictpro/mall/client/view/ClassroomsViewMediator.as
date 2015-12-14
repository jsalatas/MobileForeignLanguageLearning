package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ClassroomsViewMediator extends Mediator
	{
		[Inject]
		public var view:ClassroomsView;

		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var settings:Settings;

		[Inject]
		public var addView:AddViewSignal;
		
		override public function onRegister():void
		{
			view.title = Translation.getTranslation("Classrooms");
			view.back.add(backHandler);
			view.showDetail.add(showDetailHandler);
			view.add.add(addClassroomHandler);
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
			
			view.classrooms = classrooms;
		}
		
		private function getClassroomsError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation("Cannot Get Classrooms."));
		}

		private function backHandler():void
		{
			view.back.removeAll();
			view.showDetail.removeAll();
			view.add.removeAll();
			view.dispose();
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
		}

		private function showDetailHandler(classroom:Object):void
		{
			var parameters:Object = buildDetailParameters(classroom); 
			var detailView:ClassroomView = new ClassroomView();
			detailView.masterView = view;
			view.back.removeAll();
			view.showDetail.removeAll();
			view.add.removeAll();
			view.dispose();
			addView.dispatch(detailView, parameters, view);
		}
		
		private function buildDetailParameters(classroom:Object): ObjectProxy
		{
			var parameters:ObjectProxy = new ObjectProxy();
			parameters.classroom = classroom;
			var classrooms:ArrayList = new ArrayList();
			for (var i:int = 0; i< view.classrooms.length; i++) {
				classrooms.addItem(view.classrooms.getItemAt(i).name + " (" + view.classrooms.getItemAt(i).languageCode +")");
			}
			parameters.classrooms = classrooms; 
			if(view.parameters != null && view.parameters.hasOwnProperty('notification')) {
				parameters.notification = Object(view.parameters.notification); 
			}
			return parameters;
		}

		private function addClassroomHandler():void
		{
			var classroom:ObjectProxy = new ObjectProxy();
			classroom.languageCode = "";
			classroom.name = "";
			classroom.notes = "";
			showDetailHandler(classroom);
		}	

	}
}