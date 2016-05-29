package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ProjectModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Project;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class ProjectViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;
		
		[Inject]
		public function set projectModel(model:ProjectModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();

			if(UserModel.isStudent(runtimeSettings.user) || UserModel.isParent(runtimeSettings.user)) {
				view.disableDelete();
				view.disableOK();
			}
		}			
		
		override protected function validateDelete():Boolean
		{
			var project:Project = Project(view.parameters.vo); 
			if(project.name == null || project.name == '') {
				UI.showError("Please Enter Project's Name.");
				return false;
			}
			
			return true;
		}

	}
}