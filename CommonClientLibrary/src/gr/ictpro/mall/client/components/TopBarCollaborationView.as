package gr.ictpro.mall.client.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.mx_internal;
	
	import spark.layouts.supportClasses.LayoutBase;
	
	import assets.fxg.back;
	import assets.fxg.settings;
	import assets.fxg.textchat;
	import assets.fxg.users;
	import assets.fxg.videochat;
	import assets.fxg.whiteboard;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.runtime.Device;


	use namespace mx_internal;	

	[Event(name="backClicked", type="flash.events.MouseEvent")]
	[Event(name="whiteboardClicked", type="flash.events.MouseEvent")]
	[Event(name="videoClicked", type="flash.events.MouseEvent")]
	[Event(name="chatClicked", type="flash.events.MouseEvent")]
	[Event(name="usersClicked", type="flash.events.MouseEvent")]
	[Event(name="settingsClicked", type="flash.events.MouseEvent")]

	public class TopBarCollaborationView extends Group implements IDetailView, IParameterizedView
	{
		protected var mxmlContentGroup:Group; 

		public var whiteboardButton:Boolean = true;
		public  var videoButton:Boolean = true;
		public var chatButton:Boolean = true;
		public var usersButton:Boolean = true;
		public var settingsButton:Boolean = true;
		protected var _title:String;
		private var _titleLabel:Label; 
//		protected var mxmlContentGroup:Group; 
		private var _masterView:IVisualElement;
		private var _parameters:ViewParameters;
		private var _groupVideo:Group;
		private var _groupWhiteboard:Group;
		private var _groupChat:Group;
		private var _groupUsers:Group;
		private var _groupSettings:Group;
		private var _disableVideo:Boolean = false; 
		private var _disableWhiteboard:Boolean = false; 
		private var _disableChat:Boolean = false; 
		private var _disableUsers:Boolean = false; 
		private var _disableSettings:Boolean = false; 

		public function TopBarCollaborationView()
		{
			super();
			
			mxmlContentGroup = new Group();
			
		}
		
	
		[Bindable]
		public function set title(title:String):void
		{
			this._title = title;
			if(this._titleLabel != null) {
				this._titleLabel.text = _title;
			}
		}
		
		public function get title():String
		{
			return this._title;
		}
		
		public function dispose():void
		{
			if(parent && parent.contains(this)) {
				IVisualElementContainer(parent).removeElement(this);
			}
		}
		public function set masterView(masterView:IVisualElement):void 
		{
			this._masterView = masterView;
		}
		
		public function get masterView():IVisualElement
		{
			return this._masterView;
		}
		
		[Bindable]
		public function set parameters(parameters:ViewParameters):void
		{
			this._parameters = parameters;
		}
		
		public function get parameters():ViewParameters
		{
			return this._parameters;
		}
		
		public function invalidateChildren():void {
			removeAllElements();
			createChildren();
			if(_disableSettings) {
				disableSettings();
			}
			if(_disableVideo) {
				disableVideo();
			}
			if(_disableWhiteboard) {
				disableWhiteboard();
			}
			if(_disableUsers) {
				disableUsers();
			}
			if(_disableChat) {
				disableChat();
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var v:VerticalLayout = new VerticalLayout();
			v.gap = 0;
			super.layout = v;
			// Top Bar background
			var topBarGroup:Group = new Group();
			topBarGroup.top=0;
			topBarGroup.percentWidth=100;
			topBarGroup.height=30; //Device.getScaledSize(40);
			
			var bg:Rect = new Rect();
			bg.fill = new SolidColor(Device.getDefaultColor(0.67));
			bg.left = 0;
			bg.bottom = 0;
			bg.top = 0;
			bg.right = 0;
			topBarGroup.addElement(bg);
			
			addElement(topBarGroup);
			
			// Back button and title
			var bgroup:Group = new Group();
			var l1:HorizontalLayout = new HorizontalLayout();
			
			l1.paddingLeft = 3;
			l1.paddingRight = 2;
			l1.gap = 0;
			l1.verticalAlign = VerticalAlign.MIDDLE;
			bgroup.layout = l1;
			bgroup.left = 0;
			bgroup.top = 0;
			bgroup.height = 30; //Device.getScaledSize(40);
			
			var fxgBack:back = new back();
			fxgBack.width = Device.getScaledSize(16);
			fxgBack.height = Device.getScaledSize(15);
			
			var groupBack:Group = new Group();

			groupBack.width = 31;
			groupBack.height = 30;
			var layout1:HorizontalLayout =  new HorizontalLayout();
			layout1.paddingTop = 7;
			layout1.paddingLeft = 7; 
			layout1.paddingBottom = 8;
			layout1.paddingRight = 8; 
			groupBack.layout = layout1;
			
			
			groupBack.addElement(fxgBack);
			groupBack.addEventListener(MouseEvent.CLICK, backClickedHandler);
			bgroup.addElement(groupBack);
			
			_titleLabel = new Label();
			_titleLabel.text = _title;
			_titleLabel.left = 0;
			_titleLabel.top = 0;
			_titleLabel.bottom = 0;
			_titleLabel.right = 0;
			_titleLabel.setStyle("color", 0xffffff);
			_titleLabel.setStyle("fontSize", Device.isAndroid?14:16);
			
			bgroup.addElement(_titleLabel);
			
			topBarGroup.addElement(bgroup);
			
			
			// OK/Cancel buttons
			var ocgroup:Group = new Group();
			var l2:HorizontalLayout = new HorizontalLayout();
			l2.paddingLeft = 10;
			l2.paddingRight = 2;
			l2.gap = 0;
			l2.verticalAlign = VerticalAlign.MIDDLE;
			ocgroup.layout = l2;
			ocgroup.right = 0;
			ocgroup.top = 0;
			ocgroup.height = 30; //Device.getScaledSize(40);
			
			if(whiteboardButton) {
				var fxgWhiteboard:whiteboard = new whiteboard();
				fxgWhiteboard.width = Device.getScaledSize(14);
				fxgWhiteboard.height = Device.getScaledSize(15);
				_groupWhiteboard = new Group();
				
				_groupWhiteboard.width = 30;
				_groupWhiteboard.height = 30;
				var layout2:HorizontalLayout =  new HorizontalLayout();
				layout2.paddingTop = 7;
				layout2.paddingLeft = 8; 
				layout2.paddingBottom = 8;
				layout2.paddingRight = 8; 
				_groupWhiteboard.layout = layout2;

				
				_groupWhiteboard.addElement(fxgWhiteboard);
				_groupWhiteboard.addEventListener(MouseEvent.CLICK, whiteboardClickedHandler);
				
				ocgroup.addElement(_groupWhiteboard);
			}
			
			if(videoButton) {
				var fxgVideo:videochat = new videochat();
				fxgVideo.width = Device.getScaledSize(22);
				fxgVideo.height = Device.getScaledSize(12);
				_groupVideo = new Group();
				
				_groupVideo.width = 32;
				_groupVideo.height = 30;
				var layout3:HorizontalLayout =  new HorizontalLayout();
				layout3.paddingTop = 9;
				layout3.paddingLeft = 7; 
				layout3.paddingBottom = 9;
				layout3.paddingRight = 3; 
				_groupVideo.layout = layout3;

				
				
				_groupVideo.addElement(fxgVideo);
				_groupVideo.addEventListener(MouseEvent.CLICK, videoClickedHandler);
				
				ocgroup.addElement(_groupVideo);
			}
			
			if(chatButton) {
				var fxgChat:textchat = new textchat();
				fxgChat.width = Device.getScaledSize(16);
				fxgChat.height = Device.getScaledSize(15);
				//fxgOk.left = 10;
				_groupChat = new Group();
				
				_groupChat.width = 26;
				_groupChat.height = 30;
				var layout4:HorizontalLayout =  new HorizontalLayout();
				layout4.paddingTop = 7;
				layout4.paddingLeft = 7; 
				layout4.paddingBottom = 8;
				layout4.paddingRight = 3; 
				_groupChat.layout = layout4;

				_groupChat.addElement(fxgChat);
				
				_groupChat.addEventListener(MouseEvent.CLICK, chatClickedHandler);
				
				ocgroup.addElement(_groupChat);
			}

			if(usersButton) {
				var fxgUsers:users = new users();
				fxgUsers.width = Device.getScaledSize(19);
				fxgUsers.height = Device.getScaledSize(12);
				//fxgOk.left = 10;
				_groupUsers = new Group();
				
				_groupUsers.width = 29;
				_groupUsers.height = 30;
				var layout5:HorizontalLayout =  new HorizontalLayout();
				layout5.paddingTop = 9;
				layout5.paddingLeft = 7; 
				layout5.paddingBottom = 9;
				layout5.paddingRight = 3; 
				_groupUsers.layout = layout5;
				
				_groupUsers.addElement(fxgUsers);
				
				_groupUsers.addEventListener(MouseEvent.CLICK, usersClickedHandler);
				
				ocgroup.addElement(_groupUsers);
			}

			if(settingsButton) {
				var fxgSettings:settings= new settings();
				fxgSettings.width = Device.getScaledSize(14);
				fxgSettings.height = Device.getScaledSize(15);
				//fxgCancel.left = okButton?0:10;
				_groupSettings = new Group();
				
				_groupSettings.width = 29;
				_groupSettings.height = 30;
				var layout6:HorizontalLayout =  new HorizontalLayout();
				layout6.paddingTop = 7;
				layout6.paddingLeft = 7; 
				layout6.paddingBottom = 8;
				layout6.paddingRight = 8; 
				_groupSettings.layout = layout6;
				
				_groupSettings.addElement(fxgSettings);
				_groupSettings.addEventListener(MouseEvent.CLICK, settingsClickedHandler);
				ocgroup.addElement(_groupSettings);
			}
			
			topBarGroup.addElement(ocgroup);
			addElement(mxmlContentGroup);

		}

		override public function set layout(value:LayoutBase):void
		{
			mxmlContentGroup.layout = layout;
		}
		
		override public function set mxmlContent(value:Array):void
		{
			mxmlContentGroup.mxmlContent = value;
			invalidateDisplayList();
		}

		private function backClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("backClicked");
			dispatchEvent(e);
		}
		
		private function chatClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("chatClicked");
			dispatchEvent(e);
		}
		
		private function whiteboardClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("whiteboardClicked");
			dispatchEvent(e);
		}

		private function usersClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("usersClicked");
			dispatchEvent(e);
		}
		
		private function videoClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("videoClicked");
			dispatchEvent(e);
		}
		
		private function settingsClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("settingsClicked");
			dispatchEvent(e);
		}
		
		public function disableVideo():void {
			_disableVideo = true;
			if(_groupVideo != null) {
				_groupVideo.getChildAt(0).alpha = 0;
				_groupVideo.removeEventListener(MouseEvent.CLICK, videoClickedHandler);
			}
		}
		
		public function enableVideo():void {
			_disableVideo = false;
			if(_groupVideo != null) {
				_groupVideo.getChildAt(0).alpha = 1.0;
				_groupVideo.addEventListener(MouseEvent.CLICK, videoClickedHandler);
			}
		}

		public function disableWhiteboard():void {
			_disableWhiteboard = true;
			if(_groupWhiteboard != null) {
				_groupWhiteboard.getChildAt(0).alpha = 0;
				_groupWhiteboard.removeEventListener(MouseEvent.CLICK, whiteboardClickedHandler);
			}
		}
		
		public function enableWhiteboard():void {
			_disableWhiteboard = false;
			if(_groupWhiteboard != null) {
				_groupWhiteboard.getChildAt(0).alpha = 1.0;
				_groupWhiteboard.addEventListener(MouseEvent.CLICK, whiteboardClickedHandler);
			}
		}
		
		public function disableUsers():void {
			_disableUsers = true;
			if(_groupUsers != null) {
				_groupUsers.getChildAt(0).alpha = 0;
				_groupUsers.removeEventListener(MouseEvent.CLICK, usersClickedHandler);
			}
		}
		
		public function enableUsers():void {
			_disableUsers = false;
			if(_groupUsers != null) {
				_groupUsers.getChildAt(0).alpha = 1.0;
				_groupUsers.addEventListener(MouseEvent.CLICK, usersClickedHandler);
			}
		}

		public function disableSettings():void {
			_disableSettings = true;
			if(_groupSettings != null) {
				_groupSettings.getChildAt(0).alpha = 0;
				_groupSettings.removeEventListener(MouseEvent.CLICK, settingsClickedHandler);
			}
		}
		
		public function enableSettings():void {
			_disableSettings = false;
			if(_groupSettings != null) {
				_groupSettings.getChildAt(0).alpha = 1.0;
				_groupSettings.addEventListener(MouseEvent.CLICK, settingsClickedHandler);
			}
		}

		
		public function disableChat():void {
			_disableChat = true;
			if(_groupChat != null) {
				_groupChat.getChildAt(0).alpha = 0;
				_groupChat.removeEventListener(MouseEvent.CLICK, chatClickedHandler);
			}
		}
		
		public function enableChat():void {
			_disableChat = false;
			if(_groupChat != null) {
				_groupChat.getChildAt(0).alpha = 1.0;
				_groupChat.addEventListener(MouseEvent.CLICK, chatClickedHandler);
			}
		}

	}
}