package gr.ictpro.mall.client.components
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class DetailTabMediator extends SignalMediator
	{
		
		[Inject]
		public var view:DetailTab;
		
		[Inject]
		public var mapper:VOMapper;
		
		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public var listSuccessSignal:ListSuccessSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		private var model:AbstractModel;
		
		private var list:MultiselectDetailList;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			this.model = mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(view.vo))));
			view.tabChanged.add(showTab);
			view.detailMapper = model.detailMapper;
		}
		
		private function showTab(selectedTab:DetailMapper):void
		{
			if(selectedTab != null) {
				if(selectedTab.viewComponent != null) {
					var component:UIComponent = new selectedTab.viewComponent();
					view.tabView.removeAllElements();
					view.tabView.addElement(component);
					component["vo"] = view.vo;
					component["state"] = view.currentState;
				} else {
					var tabbedList:TabbedList = new TabbedList();
					addToSignal(tabbedList.fillChoices, fillPopupList);
					tabbedList.setCurrentState(selectedTab.readOnly?"readonly":"default");
					selectedTab.list = selectedTab.filter == null? view.vo[selectedTab.propertyName]: filterList(view.vo[selectedTab.propertyName], selectedTab.filter);
					if(selectedTab.list == null) {
						selectedTab.list = new ArrayCollection();
					}
					tabbedList.vo = view.vo;
					tabbedList.dataProvider = selectedTab.list;
					tabbedList.beforeDelete = selectedTab.beforeDelete;
					tabbedList.afterAdd = selectedTab.afterAdd;
					tabbedList.viewComponent = mapper.getEditorForVO(selectedTab.propertyClass);
					tabbedList.propertyClass = selectedTab.propertyClass;
					view.tabView.removeAllElements();
					view.tabView.addElement(tabbedList);
				}
			}
		}

		private function fillPopupList(list:MultiselectDetailList):void
		{
			var dm:DetailMapper = view.tabs.selectedItem;
			this.list=list;
			addToSignal(listSuccessSignal, success);
			addToSignal(listErrorSignal, error);
			listSignal.dispatch(dm.propertyClass);
		}
		
		private function success(voClass:Class):void
		{
			var dm:DetailMapper = view.tabs.selectedItem;
			if(voClass == dm.propertyClass) {
				var model:AbstractModel = mapper.getModelforVO(voClass);
				if(dm.addFilter == null) {
					list.dataProvider = model.list;
				} else {
					list.dataProvider = model.getFilteredList(dm.addFilter);
				}
			}
			
		}

		private function error(voClass:Class, errorMessage:String):void
		{
			var dm:DetailMapper = view.tabs.selectedItem;
			if(voClass == dm.propertyClass) {
				UI.showError(errorMessage);
			}
		}

		private function filterList(list:ArrayCollection, filter:Function):ArrayCollection 
		{
			if(list == null) {
				return new ArrayCollection();
			}
			var filteredList:ArrayCollection = new ArrayCollection(list.source);
			filteredList.filterFunction = filter;
			filteredList.refresh();
			
			return filteredList;
			
		}

	}
}