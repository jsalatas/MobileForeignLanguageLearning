package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.components.TopBarListView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.runtime.Translation;

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
				title = Translation.getTranslation("Users");
			} else if(UserModel.isAdmin(runtimeSettings.user)) {
				title = Translation.getTranslation("Students");
			} else if(UserModel.isStudent(runtimeSettings.user)) {
				title = Translation.getTranslation("Contacts");
			} else if(UserModel.isParent(runtimeSettings.user)) {
				title = Translation.getTranslation("Children");
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
			var label:String = item.profile.name + " (" + item.username + ")";
			if(UserModel.isStudent(u) && (u.classrooms == null || u.classrooms.length==0) && (UserModel.isAdmin(runtimeSettings.user) ||  UserModel.isTeacher(runtimeSettings.user))) {
				label = label + " - " + Translation.getTranslation("Unassigned");
			}
			return label;
		}

	}
}