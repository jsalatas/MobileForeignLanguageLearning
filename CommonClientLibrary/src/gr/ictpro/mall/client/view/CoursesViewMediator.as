package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.CourseModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;

	public class CoursesViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public function set courseModel(model:CourseModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();

			if(UserModel.isStudent(runtimeSettings.user) || UserModel.isParent(runtimeSettings.user)) {
				view.disableAdd();
			}
			
			view.title = Device.translations.getTranslation("Courses");
		}
	}
}