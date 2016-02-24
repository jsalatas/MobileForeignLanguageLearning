package gr.ictpro.mall.client.components
{
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.mx_internal;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;

	use namespace mx_internal;	

	[Event(name="okClicked", type="flash.events.MouseEvent")]
	[Event(name="cancelClicked", type="flash.events.MouseEvent")]
	[Event(name="deleteClicked", type="flash.events.MouseEvent")]

	public class TopBarDetailView extends TopBarView  
	{

		private var _editor:VOEditor; 
		private var _detailTab:DetailTab;
		
		protected var mxmlContentGroup:Group; 
		public var _scroller:Scroller = new Scroller();

		[Inject]
		public var mapper:VOMapper;
		
		public var detailMapper:Object; 
		
		public function TopBarDetailView()
		{
			super();
			
			mxmlContentGroup = new Group();
			
			deleteButton = true;
			cancelButton = true;
			okButton = true;
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var model:AbstractModel = (parameters!=null && parameters.vo!=null)?mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(parameters.vo)))):null;
			_scroller.percentWidth = 100;
			_scroller.percentHeight = 100;
			
			_scroller.minViewportInset = 1;
			_scroller.hasFocusableChildren = true;
			_scroller.ensureElementIsVisibleForSoftKeyboard = true;
			_scroller.viewport = mxmlContentGroup;
			addElement(_scroller);
			
			if(model != null) {
				var mainGroup:Group = new Group();
				mainGroup.percentWidth = 100;
				mainGroup.horizontalCenter = 0;
				mxmlContentGroup.addElement(mainGroup);
				
				var mainLayout:VerticalLayout = new VerticalLayout();
				mainLayout.gap = 5;
				mainLayout.paddingLeft = 10;
				mainLayout.paddingTop = 10;
				mainLayout.paddingBottom = 10;
				mainLayout.paddingRight = 10;
				mainLayout.horizontalAlign = "center";
				mainGroup.layout = mainLayout;

				var editorClass:Class = model.getEditorClass();
				editor = VOEditor(new editorClass());
				editor.id = "editor";
				editor.vo = parameters.vo;
				editor.state = currentState;
				mainGroup.addElement(editor);
				
				if(model.detailMapper.length >0 && (currentState == 'edit' || currentState == 'new')) {
					_detailTab = new DetailTab();
					_detailTab.vo = parameters.vo;
					_detailTab.state = currentState;
					mainGroup.addElement(_detailTab);
				}
			}
		}
		
		override public function set currentState(state:String):void
		{
			super.currentState = state;
			if(editor != null) {
				editor.state = state;
			}
			if(_detailTab != null && (currentState == 'edit' || currentState == 'mew')) {
				_detailTab.state = state;
			} else {
				if(_detailTab != null) {
					_detailTab = null;
					mxmlContentGroup.removeAllElements();
					invalidateChildren();
				}
			}
		}
		
		[Bindable]
		public function get editor():VOEditor
		{
			return this._editor; 
		}
			
		public function set editor(editor:VOEditor):void
		{
			this._editor = editor; 
		}
		
		
//		override public function set layout(value:LayoutBase):void
//		{
////			if(model == null) {
//				mxmlContentGroup.layout = layout;
////			}
//		}
//		
//		override public function set mxmlContent(value:Array):void
//		{
////			if(model == null) {
//				mxmlContentGroup.mxmlContent = value;
//				invalidateDisplayList();
////			}
//		}
		
		
	}
}