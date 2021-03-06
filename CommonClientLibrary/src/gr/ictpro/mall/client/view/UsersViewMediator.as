package gr.ictpro.mall.client.view
{
	import flash.utils.flash_proxy;
	
	import mx.collections.ArrayCollection;
	
	import gr.ictpro.mall.client.components.TopBarListView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;

	public class UsersViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;
		[Inject]
		public function set userModel(model:UserModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var title:String;

			if(UserModel.isAdmin(runtimeSettings.user)) {
				title = Device.translations.getTranslation("Users");
			} else if(UserModel.isAdmin(runtimeSettings.user)) {
				title = Device.translations.getTranslation("Students");
			} else if(UserModel.isStudent(runtimeSettings.user)) {
				title = Device.translations.getTranslation("Contacts");
			} else if(UserModel.isParent(runtimeSettings.user)) {
				title = Device.translations.getTranslation("Children");
			}
				
			
			view.title = title;
			TopBarListView(view).labelFunction = getLabel;
			if(UserModel.isAdmin(runtimeSettings.user) || UserModel.isTeacher(runtimeSettings.user)) {
				view.enableAdd();
			} else {
				view.disableAdd();
			}
		}
		
		private function getLabel(item:Object):String
		{
			var u:User = User(item);
			var label:String = u.toString();
			if(UserModel.isStudent(u) && (u.classrooms == null || u.classrooms.length==0) && (UserModel.isAdmin(runtimeSettings.user) ||  UserModel.isTeacher(runtimeSettings.user))) {
				label = label + " - " + Device.translations.getTranslation("Unassigned");
			}
			return label;
		}

		override protected function listSuccess(classType:Class):void
		{
			if(classType == model.getVOClass()) {
				super.listSuccess(classType);
				
				if(UserModel.isParent(runtimeSettings.user)) {
					;
					
					var filteredList:ArrayCollection = new ArrayCollection(ArrayCollection(TopBarListView(view).data).source);
					filteredList.filterFunction = UserModel.isStudent;
					filteredList.refresh();
					
					TopBarListView(view).data = filteredList;

				}
				
			}
		}
		

	}
}